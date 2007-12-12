Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXLLJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXLLJwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbXLLJwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:52:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40144 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbXLLJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:52:14 -0500
Date: Wed, 12 Dec 2007 10:51:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Get rid of FASTCALL() in include/linux/*.h
Message-ID: <20071212095155.GA23777@elte.hu>
References: <1197441790.5745.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197441790.5745.1.camel@brick>
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

> Now that x86 uses regparm(3) by default, we can get rid of the 
> FASTCALL() macro.  This gets rid of it in all linux/include header 
> files.

i suspect this patch is for Andrew and -mm.

i've picked your other, x86 unification patches up into x86.git - they 
look fine.

	Ingo
