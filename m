Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbYJEQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbYJEQnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758438AbYJEQif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:38:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50030 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760256AbYJEQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:38:32 -0400
Date: Sun, 5 Oct 2008 18:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] dumpstack: x86: various small unification steps
Message-ID: <20081005163820.GA18055@elte.hu>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm> <20081005093523.GE16819@elte.hu> <20081005094615.GA27621@elte.hu> <20081005103936.GA15118@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005103936.GA15118@mailshack.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0034]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> After "dumpstack: x86: various small unification steps", the
> assembler gives the following compile error. The error is in
> dumpstack_64.c.
> 
> {standard input}: Assembler messages:
> {standard input}:720: Error: Incorrect register `%rbx' used with `l' suffix
> {standard input}:1340: Error: Incorrect register `%r12' used with `l' suffix
> 
> Indeed the suffix in get_bp() was wrong.
> 
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

applied to tip/x86/dumpstack, thanks. I've again started testing it.

	Ingo
