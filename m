Return-Path: <linux-kernel-owner+w=401wt.eu-S1764043AbXHFLMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764043AbXHFLMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXHFLL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:11:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXHFLL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:11:56 -0400
Date: Mon, 6 Aug 2007 13:11:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROFILE_NMI kernel config symbol
Message-ID: <20070806111150.GB29370@elte.hu>
References: <46B1D26E.2010508@free.fr> <46B6E166.6090507@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6E166.6090507@free.fr>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* John Sigler <linux.kernel@free.fr> wrote:

> John Sigler wrote:
> 
> >The -rt patch includes the following update:
> >
> >Index: linux/arch/i386/oprofile/Kconfig
> >===================================================================
> >--- linux.orig/arch/i386/oprofile/Kconfig
> >+++ linux/arch/i386/oprofile/Kconfig
> >@@ -15,3 +15,6 @@ config OPROFILE
> >
> >       If unsure, say N.
> >
> >+config PROFILE_NMI
> >+    bool
> >+    default y
> >
> >
> >What is the purpose of the PROFILE_NMI config symbol?
> >(It does not seem to be used anywhere else in the -rt patch.)
> 
> Should I provide a patch removing this configuration option?

indeed it's a leftover - i've zapped it.

	Ingo
