Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbYAFPEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbYAFPEh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYAFPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:04:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbYAFPE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:04:29 -0500
Date: Sun, 6 Jan 2008 16:04:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification -v2
Message-ID: <20080106150417.GA14146@elte.hu>
References: <4780EC61.4020007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4780EC61.4020007@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miguel Botón <mboton@gmail.com> wrote:

> ioport_{32|64}.c unification.
> 
> This patch unifies the code from the ioport_32.c and ioport_64.c 
> files.
> 
> Tested and working fine with i386 and x86_64 kernels.

in what way have you tested it? Have you tried iopl() and ioperm() 
syscalls to check whether they properly block/allow port IO?

	Ingo
