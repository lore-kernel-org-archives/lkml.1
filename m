Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZGUKWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZGUKWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZGUKWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:22:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38497 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbZGUKWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:22:00 -0400
Date: Tue, 21 Jul 2009 12:21:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Re: Support for synaptic touchscreen in HTC dream
Message-ID: <20090721102153.GE4133@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> disable_irq_nosync or convert this to request_threaded_irq(...).
> >> Please see recent discussion on linux-input for MAX key switch
> >> controller.
> >
> > Do you have a link? (I replaced it with disable_irq_nosync, if that is
> > enough...)
> >
> 
> link: http://patchwork.kernel.org/patch/35515/

Thanks!

> >> > +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> >>
> >> check for SMBUS? I have added linux-i2c as this driver has i2c bits,
> >> so not removing any code.
> >
> > I guess this driver is only probed on mach-pxa... on machines that
> > have the neccessary hardware.
> 
> Because this driver is using smbus i2c apis, it will be good to add
> that check too.

So I should do something like

if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
	...

in addition?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
