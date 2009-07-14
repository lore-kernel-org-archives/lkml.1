Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZGNJqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZGNJqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZGNJqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:46:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38816 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZGNJqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:46:53 -0400
Date: Tue, 14 Jul 2009 11:46:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Arve Hj?nnev?g <arve@android.com>, Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090714094646.GC2076@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz> <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com> <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <1247535863.16528.6.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247535863.16528.6.camel@Joe-Laptop.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-07-13 18:44:23, Joe Perches wrote:
> On Mon, 2009-07-13 at 18:29 -0700, Arve Hj??nnev??g wrote:
> > On Mon, Jul 13, 2009 at 3:07 PM, Pavel Machek<pavel@ucw.cz> wrote:
> > > -                       printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
> > > +                       printk(KERN_ERR "ts_work: i2c_transfer failed\n");
> > This will make it harder to read the kernel logs since the driver is 
> > no longer specified.
> 
> How about converting to:
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
> or
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> and pr_<level>()

Good idea, thanks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
