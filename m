Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZASRJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZASRJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZASRJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:09:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZASRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:09:45 -0500
Date: Mon, 19 Jan 2009 18:09:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Pavel Machek <pavel@suse.cz>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc1: [SOLVED] thinkpad problems during resume
Message-ID: <20090119170909.GB31044@elte.hu>
References: <20090113081316.GA2292@elf.ucw.cz> <200901171648.34155.borntraeger@de.ibm.com> <49723602.4090202@sgi.com> <200901180042.40284.borntraeger@de.ibm.com> <4974B160.80808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974B160.80808@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> Christian Borntraeger wrote:
> >> Could you try one more experiment?  With your working system, please cherry
> >> pick these commits and try it again?
> >>
> >> 68564a4... work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
> >> e1d9ec6... work_on_cpu: Use our own workqueue.
> >> 6eb714c... cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and
> >> drv_write
> >>
> >> From
> >> git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for
> >> -ingo.git
> >>
> >> If that works, then try and un-revert e39ad415ac and see if it's fixed as
> >> well?
> > 
> > Yes that works.
> > 
> > 29-rc2 + your 3 patches cherry-picked + revert of 
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703( usb problem) can suspend/resume. 
> > If you like, you can add an
> > Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > to your three patches.
> > 
> > 
> Thanks Christian!

Great.

Mike, could you please prepare a separate, linus/master based 'fixes' 
branch that cherry-picks these commits? (they overlap existing commits in 
cpus4096 which is a bit unfortunate but not that bad as long as it's done 
within reason - Git will sort it out.)

	Ingo
