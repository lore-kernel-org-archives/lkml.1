Return-Path: <linux-kernel-owner+w=401wt.eu-S932186AbXGaQ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbXGaQ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXGaQ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:26:42 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:22811 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758693AbXGaQ0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:26:41 -0400
Message-Id: <46AF2A1D.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 12:26:37 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/2][RFC] VFCIPI v3
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
 <1185891957.12034.12.camel@twins> <46AF1DA6.BA47.005A.0@novell.com>
 <1185896412.12034.17.camel@twins> <46AF2752.BA47.005A.0@novell.com>
 <1185898941.12034.22.camel@twins>
In-Reply-To: <1185898941.12034.22.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 31, 2007 at 12:22 PM, in message <1185898941.12034.22.camel@twins>,
Peter Zijlstra <peterz@infradead.org> wrote: 
> On Tue, 2007-07-31 at 12:14 -0400, Gregory Haskins wrote:
> 
>> Out of curiosity and for my own edification:  What *is* GFP_ATOMIC meant 
> for?
> 
> It is meant as you used it, _except_ for !PREEMPT_RT.
> 
> With PREEMPT_RT all allocators are fully preemptable, that is both the
> slab as well as the underlying page allocator.
> 
> Allocation from atomic context is a BUG() with -rt.

Thanks for the clarification!
-Greg

