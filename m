Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXLKIji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXLKIji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXLKIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:39:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXLKIja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:39:30 -0500
Date: Tue, 11 Dec 2007 09:39:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Unify mmap_{32|64}.c
Message-ID: <20071211083917.GB20172@elte.hu>
References: <1196889830.10408.50.camel@brick> <20071209081324.GB4509@elte.hu> <1197301855.1799.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197301855.1799.1.camel@brick>
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

> mmap_is_ia32 always true for X86_32, or while emulating IA32 on X86_64
> 
> Randomization not supported on X86_32 in legacy layout.  Both layouts 
> allow randomization on X86_64.

thanks for sorting this out - this looks really clean now. I've added 
your patch to x86.git.

	Ingo
