Return-Path: <linux-kernel-owner+w=401wt.eu-S934322AbXLPPcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbXLPPcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 10:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXLPPcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 10:32:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXLPPcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 10:32:14 -0500
Date: Sun, 16 Dec 2007 16:31:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] x86: Final unification of local_{32|64}.h
Message-ID: <20071216153158.GA891@elte.hu>
References: <1197806669.3749.44.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197806669.3749.44.camel@brick>
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

> No differences except for the defintion of local_add_return on X86_64. 
> The X86_32 version is just fine as it is protected with ifdef 
> CONFIG_M386 so use it directly.

thanks, i've applied your 4 patches to x86.git.

btw., now that we have a single unified file, it might make sense to fix 
these checkpatch complaints:

  total: 10 errors, 1 warnings, 257 lines checked

in case you are interested ;-)

	Ingo
