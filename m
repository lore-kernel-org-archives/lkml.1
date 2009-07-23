Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZGWOzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZGWOzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZGWOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:55:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52786 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZGWOzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:55:43 -0400
Date: Thu, 23 Jul 2009 16:55:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090723145537.GA28158@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721113642.GC13286@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +static irqreturn_t synaptics_ts_hardirq(int irq, void *dev_id)
> > +{
> > +	disable_irq_nosync(irq);
> > +	return IRQ_WAKE_THREAD;
> 
> Are you sure that this is going to work?  The IRQ thread code will not

No, I'm not. I copied it from somewhere and could not really test it.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
