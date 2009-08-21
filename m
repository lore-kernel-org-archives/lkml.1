Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZHVMHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZHVMHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 08:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZHVMHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 08:07:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60126 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbZHVMHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 08:07:23 -0400
Date: Fri, 21 Aug 2009 16:23:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: soni.trilok@gmail.com, greg@kroah.com, arve@android.com,
       linux-kernel@vger.kernel.org, swetland@google.com,
       dmitry.torokhov@gmail.com, dtor@mail.ru, linux-input@vger.kernel.org,
       linux-i2c@vger.kernel.org
Subject: Re: Synaptics touchscreen for HTC Dream: check that smbus is
	available
Message-ID: <20090821142305.GA1599@ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721102153.GE4133@elf.ucw.cz> <5d5443650907210334k3f562cebsc665511a161c8639@mail.gmail.com> <20090808134049.GA13083@elf.ucw.cz> <20090817164759.43c39f2d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817164759.43c39f2d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-08-17 16:47:59, Andrew Morton wrote:
> On Sat, 8 Aug 2009 15:40:50 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > >> Because this driver is using smbus i2c apis, it will be good to add
> > > >> that check too.
> > > >
> > > > So I should do something like
> > > >
> > > > if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WORD_DATA))
> > > > __ __ __ __...
> > > >
> > > > in addition?
> > > 
> > > Yes.
> > 
> > Ok, here it is.
> > 
> > --- 
> > 
> > Check that SMBUS APIs are available in touchscreen driver.
> 
> Why?

Well, the touchscreen driver uses those APIs, and I was told I should
check. It does not matter for htc dream-like machines, but someone
might want  to run it on pc...

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
