Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYGCOQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYGCOQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYGCOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:16:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbYGCOQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:16:18 -0400
Date: Thu, 3 Jul 2008 16:15:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Greg KH <gregkh@suse.de>, x86@kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: x86: Add /sys/firmware/memmap
Message-ID: <20080703141543.GA26416@elte.hu>
References: <1214565175-21512-1-git-send-email-bwalle@suse.de> <20080627181833.GA7735@suse.de> <20080627203409.3bc891e3@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627203409.3bc891e3@kopernikus.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bernhard Walle <bwalle@suse.de> wrote:

> * Greg KH <gregkh@suse.de> [2008-06-27 11:18]:
> > 
> > Looks good, want me to take this through my tree (due to the firmware
> > core change)?  If so, can you get an ack on the x86 portion from the
> > respective people as well?
> 
> Well, the x86 part only applies on tip (because your tree doesn't have 
> the e820_{32,64} -> e820 merge). So, wouldn't it easier to ack that 
> patch from your side and merge via tip?

Bernhard, i've created a new -tip topic for your changes: 
tip/sysfs/firmware-mmap. It is available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sysfs/firmware-mmap

This will become a 2-commit topic branch once the dependent x86 bits are 
upstream. At that point Greg will be able to pull it from -tip and push 
it out via the sysfs tree.

I've added it to the tip/master integration rules to give it testing and 
to make sure any subsequent x86 changes stay in sync with the e820 API 
changes your patches required.

	Ingo
