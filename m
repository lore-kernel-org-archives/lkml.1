Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZGNJXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZGNJXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZGNJXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:23:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38803 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZGNJXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:23:36 -0400
Date: Tue, 14 Jul 2009 11:23:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090714092311.GA1997@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz> <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com> <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-13 18:29:52, Arve Hj?nnev?g wrote:
> On Mon, Jul 13, 2009 at 3:07 PM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Mon 2009-07-13 22:57:49, Pavel Machek wrote:
> >> Hi!
> >>
> >> I'm looking at synaptic touchscreen driver... who should be listed as
> >> an author?
> >>
> >> Changes I have so far are...
> >>
> >> checkpatch only has minor complains -- lines over 80 characters -- but
> >> the code is _way_ too deeply nested with way too little functions.
> >
> > Here's better cleanup. But... some functions are still _way_ too big.
> >
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> > index 339083e..fa3404f 100644
> > --- a/drivers/input/touchscreen/Kconfig
> > +++ b/drivers/input/touchscreen/Kconfig
> > @@ -94,6 +94,9 @@ config TOUCHSCREEN_GUNZE
> >  config TOUCHSCREEN_ELAN_I2C_8232
> >        tristate "Elan 8232 I2C touchscreen"
> >        depends on I2C
> > +       help
> > +         This enables support for Elan over I2C based touchscreens.
> > +         Such touchscreen is used in HTC Dream.
> >
> 
> Why is this here? This driver is not related to elan touchscreens.

I forgot to strip it. Can you apply it to linux-msm tree so that it does
not get lost? 

> >  static struct workqueue_struct *synaptics_wq;
> >
> >  struct synaptics_ts_data {
> > -       uint16_t addr;
> > +       u16 addr;
> 
> What is the point of this change?

u16 is both shorter and more common in kernel, so use that.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
