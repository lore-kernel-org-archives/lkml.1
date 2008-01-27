Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbYA0WnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbYA0WnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYA0WnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:43:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYA0WnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:43:11 -0500
Date: Sun, 27 Jan 2008 23:42:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c -
	take 2
Message-ID: <20080127224258.GA22018@elte.hu>
References: <20080127231527.2ea40804@paolo-desktop> <479D067E.3010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479D067E.3010100@gmail.com>
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


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Looks like it would be better to proceed in the following manner:
> 
> 1) remove dead code (no md5 change);
> 2) reformat the lines to use tabs, not spaces (no md5 change);
> 3) address the "else-braces" and "single statement block" errors
>    (no md5 change);
> 4) remove all unnecessary spaces (no md5 change);
> 5) add the KERN_ macros (md5 will change).
> 6) address remaining checkpatch complaints (no md5 change wrt #5
>    above).
> 
> Each item above might get into a separate patch.

agreed, that looks like a sensible splitup for such larger cleanup 
patches.

(also, a debug switch that disabled the FPU on modern CPUs and which 
forced math-emu would be nice as well.)

	Ingo
