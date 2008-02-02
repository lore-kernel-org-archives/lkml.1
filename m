Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbYBBJFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbYBBJFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760333AbYBBJEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:04:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760142AbYBBJEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:04:45 -0500
Date: Sat, 2 Feb 2008 10:04:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86: add function prototype to vm86.h
Message-ID: <20080202090434.GB17348@elte.hu>
References: <1201938485.1844.6.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201938485.1844.6.camel@brick>
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

> Global functions should include their prototypes.

thanks, i've applied all three cleanup patches of yours.

one minor detail:

> +struct pt_regs * save_v86_state(struct kernel_vm86_regs *);

the proper form is:

   struct pt_regs *save_v86_state(struct kernel_vm86_regs *);

(note the lack of space)

	Ingo
