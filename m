Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbZLJReZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbZLJReZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761266AbZLJReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:34:24 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:53012 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbZLJReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:34:24 -0500
Date: Thu, 10 Dec 2009 11:34:03 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
In-Reply-To: <20091210075454.GB25549@elte.hu>
Message-ID: <alpine.DEB.2.00.0912101131200.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com> <20091210075454.GB25549@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Ingo Molnar wrote:

> I.e. why not expose these stats via perf events and counts as well,
> beyond the current (rather minimal) set of MM stats perf supports
> currently?

Certainly one can write perf events that do a simular thing but that is
beyond the scope of the work here. This is the result of a test program.
The point here is to avoid fault regressions while introducing new process
specific counters that are then used by other VM code to make decisions
about a process.


