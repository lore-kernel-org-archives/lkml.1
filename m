Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYADHjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYADHjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYADHi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:38:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYADHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:38:57 -0500
Date: Fri, 4 Jan 2008 08:38:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0 of 8] x86: unify asm/page.h
Message-ID: <20080104073837.GB17447@elte.hu>
References: <patchbomb.1199391057@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1199391057@localhost>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> Here's a series which concentrates on unifying and cleaning up 
> asm-86/page*.h.  Each patch in the series restricts itself to doing 
> one thing fairly simply, so it should be fairly low-risk and easy to 
> bisect.

thanks Jeremy, i have applied your patches to x86.git.

> The early version of this patch got rid of asm/page_32|64.h entirely, 
> but I decided the resulting #ifdef hell was too hard to deal with, so 
> I moved purely 32/64-bit specific stuff into their own files.

agreed - and the result certainly looks clean.

	Ingo
