Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZCXJL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZCXJL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZCXJLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:11:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbZCXJLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:11:50 -0400
Date: Tue, 24 Mar 2009 10:10:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090324091035.GA6605@elte.hu>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain> <20090322124818.GA31466@elte.hu> <20090324061429.GH7278@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324061429.GH7278@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Sure.  Here's a revert, it is a partial revert which compiles 
> vsmp64.c only for 64bit architectures.

hm, why dont you add 'depends on X86_64' to the X86_VSMP Kconfig 
rules? That's far clear - or am i missing some detail?

	Ingo
