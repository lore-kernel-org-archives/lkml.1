Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYG1SCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYG1SCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYG1SB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:01:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYG1SBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:01:55 -0400
Date: Mon, 28 Jul 2008 20:01:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 00/11] x86: AMD microcode patch loading support v2
Message-ID: <20080728180141.GB2937@elte.hu>
References: <20080728164411.490752571@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728164411.490752571@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: checkpatch.pl]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oruba <peter.oruba@amd.com> wrote:

> AMD microcode patch loader v2, rebased to Linux master.

applied to tip/x86/microcode - thanks Peter.

One open issue i noticed is the checkpatch warnings:

 $ scripts/checkpatch.pl --file arch/x86/kernel/microcode_amd.c
 total: 0 errors, 10 warnings, 1 checks, 521 lines checked

 $ scripts/checkpatch.pl --file arch/x86/kernel/microcode.c
 total: 2 errors, 12 warnings, 477 lines checked

 $ scripts/checkpatch.pl --file arch/x86/kernel/microcode_intel.c
 total: 1 errors, 11 warnings, 546 lines checked

Could you send delta patch(es) to fix them up? You can pick up the 
committed patches via:

  http://people.redhat.com/mingo/tip.git/README

and do something like:

  git-checkout tip/master
  git-merge tip/x86/microcode

to get the latest code plus your changes.

Thanks,

	Ingo
