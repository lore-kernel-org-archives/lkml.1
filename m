Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbYAAPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbYAAPz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbYAAPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49225 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbYAAPgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:49 -0500
Date: Tue, 1 Jan 2008 16:35:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Message-ID: <20080101153558.GJ4434@elte.hu>
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4778E8B0.6010400@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Harvey Harrison wrote:
> > Make the control flow of kprobe_handler more obvious.
> > 
> > Collapse the separate if blocks/gotos with if/else blocks
> > this unifies the duplication of the check for a breakpoint
> > instruction race with another cpu.
> 
> This is a patch derived from kprobe_handler of the ARM kprobes port. 
> This further simplifies the current x86 kprobe_handler. The resulting 
> definition is smaller, more readable, has no goto's and contains only 
> a single call to get_kprobe.

hm, this patch does not apply to x86.git#mm, due to the fixes, 
unifications and cleanups done there. Could you send a patch against -mm 
or against x86.git? (see the tree-fetching instructions below) Thanks,

	Ingo

--------------{ x86.git instructions }---------->

 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

(do subsequent pulls via "git-pull --force", as we frequently rebase the
git tree. NOTE: this might override your own local changes, so do this
only if you dont mind about losing thse changes in that tree.)

