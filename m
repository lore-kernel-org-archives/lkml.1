Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYCUKw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYCUKw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYCUKwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:52:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbYCUKwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:52:49 -0400
Date: Fri, 21 Mar 2008 11:52:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/12] x86_64: fix setup_node_bootmem to support big
	mem excluding with memmap
Message-ID: <20080321105231.GT20420@elte.hu>
References: <200803181237.33861.yhlu.kernel@gmail.com> <200803191405.03495.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191405.03495.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1098]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> need to apply it after
> 	[PATCH] mm: make reserve_bootmem can crossed the nodes

this too should go via Andrew due to the mm/bootmem.c dependency. (can 
pick it up into x86.git as well if the mm/bootmem.c goes into -git)

	Ingo
