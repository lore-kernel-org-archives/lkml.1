Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbXLEMa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbXLEMa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLEMaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:30:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52101 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXLEMav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:30:51 -0500
Date: Wed, 5 Dec 2007 13:30:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86_64: define all _PAGE_* in terms of _PAGE_BIT_*
Message-ID: <20071205123033.GA15394@elte.hu>
References: <11966016811565-git-send-email-joerg.roedel@amd.com> <11966016814058-git-send-email-joerg.roedel@amd.com> <20071204123809.GD27286@elte.hu> <20071204150652.GJ6945@amd.com> <20071204210751.GH32018@elte.hu> <20071205105236.GB23093@amd.com> <20071205112758.GA6143@elte.hu> <20071205114225.GC23093@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205114225.GC23093@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> > > > > Sorry, forgot to check the patches before submission. Will 
> > > > > cleanup and resubmit soon.
> > > > 
> > > > please if possible send a delta against x86.git, not a 
> > > > replacement patch. It's easier for the patchflow.
> > > 
> > > Not sure I understand you right here. Do you mean a patch on top 
> > > of my previous patches?
> > 
> > yeah - that's easier to pick up for me (because i've already got 
> > your series applied), and it's also easier for you as well. It also 
> > makes sense to generally split style fixes from substantial patches. 
> > (in the cases where there are pre-existing style problems in the 
> > code)
> 
> Ok, thanks. Will prepare a patch on top of my first patch series.

it's all in the mm branch of x86.git:

 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86       # (1)
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm

so the easiest is to do patches just against that tree.

NOTE: the x86.git tree is frequently regenerated, so it can not be 
rolling upgraded the usual git way via typing 'git-pull' - you have to 
zap your x86 branch and re-pull:

 git-checkout master
 git-branch -D x86     # this zaps everything!

and repeat from (1) above.

	Ingo
