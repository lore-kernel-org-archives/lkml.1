Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXL3Np5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXL3Np5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXL3Npt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:45:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXL3Npt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:45:49 -0500
Date: Sun, 30 Dec 2007 14:42:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Cosmetic fixes fault_{32|64}.c
Message-ID: <20071230134229.GH16946@elte.hu>
References: <1198511207.6323.19.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198511207.6323.19.camel@brick>
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

> First step towards unifying these files.
> - Checkpatch trailing whitespace fixes
> - Checkpatch indentation of switch statement fixes
> - Checkpatch single statement ifs need no braces fixes
> - Checkpatch consistent spacing after comma fixes
> - Introduce defines for pagefault error bits from X86_64 and add useful
>   comment from X86_32.  Use these defines in X86_32 where obvious.
> - Unify comments between 32|64 bit
> - Small ifdef movement for CONFIG_KPROBES in notify_page_fault()
> - Introduce X86_64 only case statement
> 
> No Functional Changes.

thanks, applied.

	Ingo
