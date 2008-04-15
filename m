Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbYDOHLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbYDOHLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYDOHLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:11:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYDOHLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:11:38 -0400
Date: Tue, 15 Apr 2008 09:11:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, hannes@saeurebad.de, ak@suse.de,
       clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm
	tree
Message-ID: <20080415071120.GB15499@elte.hu>
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
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


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> Subject: bootmem: node-setup agnostic free_bootmem()
> From: Johannes Weiner <hannes@saeurebad.de>
> 
> Make free_bootmem() look up the node holding the specified address 
> range which lets it work transparently on single-node and multi-node 
> configurations.

this patch does not fix the bug Yinghai's (now dropped) patches solved: 
reserve_early() allocations. So NAK until the full problem has been 
sorted out ...

	Ingo
