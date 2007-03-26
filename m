Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXCZEFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXCZEFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXCZEFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:05:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34500 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933158AbXCZEFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:05:06 -0400
Date: Mon, 26 Mar 2007 06:05:09 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Message-ID: <20070326040509.GU16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184919.GW752@stusta.de> <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6a2187b0703251825l2b2ab9d3j43e17523cbca87ac@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 09:25:51AM +0800, Jeff Chua wrote:
> On 3/19/07, Adrian Bunk <bunk@stusta.de> wrote:
> 
> >Subject    : ThinkPad doesn't resume from suspend to RAM
> >References : http://lkml.org/lkml/2007/2/27/80
> >             http://lkml.org/lkml/2007/2/28/348
> >Submitter  : Jens Axboe <jens.axboe@oracle.com>
> >             Jeff Chua <jeff.chua.linux@gmail.com>
> >Status     : unknown
> >
> >
> >Subject    : suspend to disk hangs
> >References : http://lkml.org/lkml/2007/3/6/142
> >Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> >Status     : unknown
> 
> The good news is on 2.6.21-rc5, suspend to disk, and resume from disk works.
> But, it only works with CONFIG_NO_HZ unset.

Thanks for this information.

> Setting CONFIG_NO_HZ will cause suspend to disk to hang just before
> saving memory to disk.

Thanks, noted.

> Resume from RAM (s2ram) still broke (tried with or without
> CONFIG_NO_HZ). Suspend to RAM seems ok, but upon resume, the screen
> will only display "inu" and only after pressing the power button will
> the system return to console. But "date" still doesn't advance.

This might be related to the following regression:

Subject    : first disk access after resume takes several minutes
             ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
References : http://lkml.org/lkml/2007/3/8/117
             http://lkml.org/lkml/2007/3/25/20
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
             Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged

> Thanks,
> Jeff.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

