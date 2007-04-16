Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbXDPBQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbXDPBQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 21:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXDPBQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 21:16:31 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51677 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754255AbXDPBQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 21:16:30 -0400
Date: Mon, 16 Apr 2007 03:16:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070416011636.GO3691@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070416005446.GB21217@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 08:54:46PM -0400, Dave Jones wrote:
> On Mon, Apr 16, 2007 at 02:37:23AM +0200, Adrian Bunk wrote:
> 
>  > Subject    : ThinkPad X60: resume no longer works  (PCI related?)
>  >              workaround: booting with "hpet=disable"
>  > References : http://lkml.org/lkml/2007/3/13/3
>  > Submitter  : Dave Jones <davej@redhat.com>
>  >              Jeremy Fitzhardinge <jeremy@goop.org>
>  > Caused-By  : PCI merge
>  >              commit 78149df6d565c36675463352d0bfe0000b02b7a7
>  > Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>  >              Rafael J. Wysocki <rjw@sisk.pl>
>  > Status     : unknown
> 
> note that this workaround doesn't seem to work in all cases.
> Mine may a slightly different model (I have the tablet version)
> but disabling hpet shows the same regression.
> I've been fighting Eric's USB debug cable code in the hope
> of getting _something_ useful out of it other than a black screen,
> but I've been getting nowhere with it.

I'm not sure why I thought you two ran into the same regression.

So "hpet=disable" worked for Jeremy but not for you, IOW: you two were 
running into different regressions?

@Jeremy:
If this is true, is your HPET related related regression still present 
in -rc7?

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

