Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXBDUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXBDUl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXBDUl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:41:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59681 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752549AbXBDUlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:41:25 -0500
Date: Sun, 4 Feb 2007 21:41:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Christoph Schmid <chris@schlagmichtod.de>, linux-kernel@vger.kernel.org
Subject: Re: is there any Hard-disk shock-protection for 2.6.18 and above?
Message-ID: <20070204204115.GC2067@elf.ucw.cz>
References: <7ibks-1fg-15@gated-at.bofh.it> <7kpjn-7th-23@gated-at.bofh.it> <7kDFF-8rd-29@gated-at.bofh.it> <87d5783fms.fsf@denkblock.local> <20061130171910.GD1860@elf.ucw.cz> <87k61bpuk4.fsf@denkblock.local> <20061202115709.GC4030@ucw.cz> <87wt50wokd.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wt50wokd.fsf@denkblock.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi1

> >> >> +module_param_named(protect_method, libata_protect_method, int, 0444);
> >> >> +MODULE_PARM_DESC(protect_method, "hdaps disk protection method  (0=autodetect, 1=unload, 2=standby)");
> >> >
> >> > Should this be configurable by module parameter? Why not tell each
> >> > unload what to do?
> [...]
> >> > Is /sys interface right thing to do?
> >> 
> >> Probably, you're right here. Since this feature is actually drive
> >> specific, it should not really be set globally as a libata or ide-disk
> >> parameter but specifically for each drive connected. Perhaps we should
> >> add another attribute to /sys/block/*/queue or enhance the scope of
> >> /sys/block/*/queue/protect?
> >
> > Certainly better than current solution. Or maybe ioctl similar to wat
> > hdparm uses?
> 
> I'm not quite sure what you have in mind wrt ioctls. I'm still
> convinced that the administrator should take a conscious decision when
> forcing an idle immediate with unload feature on a drive which doesn't
> announce this capability according to the specs. This is because I
> have no idea as to how drives might react if they don't support it.
> Perhaps we should consult linux-ide on this topic.

Yep, I guess linux-ide would have some comments.

> So, here is a patch in which your remarks and suggestions have been
> incorporated. Additionally, I've added the requested kernel doc file

Additional suggestion is to keep lines < 80 columns.... Sorry it took
me so long to comment.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
