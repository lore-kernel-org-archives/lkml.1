Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbZCCQFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbZCCQFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZCCQFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:05:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbZCCQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:05:13 -0500
Date: Tue, 3 Mar 2009 17:05:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH] generic debug pagealloc
Message-ID: <20090303160503.GA6538@elte.hu>
References: <20090303160103.GB5812@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303160103.GB5812@localhost.localdomain>
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


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> CONFIG_DEBUG_PAGEALLOC is now supported by x86, powerpc, sparc 
> (64bit), and s390. This patch implements it for the rest of 
> the architectures by filling the pages with poison byte 
> patterns after free_pages() and verifying the poison patterns 
> before alloc_pages().
> 
> This generic one cannot detect invalid read accesses and it 
> can only detect invalid write accesses after a long delay. But 
> it is an feasible way for nommu architectures.

if every architecture supports it now then i guess this config 
switch can go away:

> +config ARCH_SUPPORTS_DEBUG_PAGEALLOC
> +	def_bool y

	Ingo
