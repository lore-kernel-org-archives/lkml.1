Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZCHVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZCHVOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZCHVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:14:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50357 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZCHVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:14:31 -0400
Date: Sun, 8 Mar 2009 22:14:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: hp accelerometer: add freefall detection
Message-ID: <20090308211423.GB17680@elf.ucw.cz>
References: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org> <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org> <4992C57E.9050109@tremplin-utc.net> <200902141701.02876.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902141701.02876.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-02-14 17:01:01, Frans Pop wrote:
> Hi Pavel,
> 
> > +++ b/drivers/hwmon/lis3lv02d.c
> [...]
> > +static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
> [...]
> > +       if (ret) {
> > +               clear_bit(0, &adev.misc_opened);
> > +               printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", ad
> > +               return -EBUSY;
> > +       }
> > +       lis3lv02d_increase_use(&adev);
> > +       printk("lis3: registered interrupt %d\n", adev.irq);
> 
> Is this a debug printk that should be removed altogether or should it
> be given a proper format and KERN_DEBUG?

It should be deleted, yes. I'll prepare the patch once previous
changes are merged.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
