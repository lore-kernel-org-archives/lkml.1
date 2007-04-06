Return-Path: <linux-kernel-owner+w=401wt.eu-S1766928AbXDFMcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766928AbXDFMcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 08:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766929AbXDFMcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 08:32:03 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:47937 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766928AbXDFMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 08:32:01 -0400
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070405194942.1414c030.dada1@cosmosbay.com>
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 14:31:58 +0200
Message-Id: <1175862718.6483.174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 19:49 +0200, Eric Dumazet wrote:
> Hi all
> 
> I'm pleased to present this patch which improves linux futexes performance and 
> scalability, merely avoiding taking mmap_sem rwlock.
> 
> Ulrich agreed with the API and said glibc work could start as soon
> as he gets a Fedora kernel with it :)
> 
> Andrew, could we get this in mm as well ? This version is against 2.6.21-rc5-mm4
> (so supports 64bit futexes)
> 
> In this third version I dropped the NUMA optims and process private hash table,
> to let new API come in and be tested.

Good work, Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

