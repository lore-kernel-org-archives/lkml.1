Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYCUKu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYCUKu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 06:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYCUKuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 06:50:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35043 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYCUKuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 06:50:14 -0400
Date: Fri, 21 Mar 2008 11:50:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] x86_64: make reserve_bootmem_generic to use new
	reserve_bootmem
Message-ID: <20080321105001.GR20420@elte.hu>
References: <200803181237.33861.yhlu.kernel@gmail.com> <200803191404.48211.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803191404.48211.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> [PATCH] x86_64: make reserve_bootmem_generic to use new reserve_bootmem
> 
> 	[PATCH] mm: make reserve_bootmem can crossed the nodes
> 
> provides new resever_bootmem, let reserve_bootmem_generic use that.
> 
> acctualy reserve_bootme_generic is used to reserve initramdisk. so we 
> can make sure even bootloader or kexec load that cross the nodes, 
> reserve_bootmem still works.

.25 fix, correct? But due to dependency on the mm/bootmem.c change this 
patch should go via Andrew.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
