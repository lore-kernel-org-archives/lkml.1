Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbXLOHhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbXLOHhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXLOHg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:36:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33247 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXLOHg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:36:59 -0500
Date: Sat, 15 Dec 2007 08:36:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use helper in kprobes{32|64}.c
Message-ID: <20071215073644.GC12110@elte.hu>
References: <1197680107.898.81.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197680107.898.81.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> x86: Use helper in kprobes{32|64}.c

thanks, i've applied your kprobes pre-unification patches to x86.git. 

While we are at it, it might be nice to reduce the numbers of checkpatch 
warnings:

 $ scripts/checkpatch.pl --file arch/x86/kernel/kprobes*.c  | grep total
 total: 10 errors, 9 warnings, 959 lines checked
 total: 10 errors, 8 warnings, 923 lines checked

to 0/0 ? :-) (but that can happen after the unification too)

	Ingo
