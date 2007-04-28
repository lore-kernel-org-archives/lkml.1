Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXD1FU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXD1FU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030782AbXD1FU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:20:28 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:5096 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbXD1FUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:20:17 -0400
Date: Sat, 28 Apr 2007 06:20:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: rohitseth@google.com, Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
In-Reply-To: <4632B9C8.40400@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704280616470.9554@blonde.wat.veritas.com>
References: <20070425205548.fd51b301.akpm@linux-foundation.org> 
 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com> 
 <4631E49C.2030501@yahoo.com.au> <1177723479.13482.371.camel@galaxy.corp.google.com>
 <4632AAB4.6030303@yahoo.com.au> <4632B9C8.40400@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Apr 2007 05:20:15.0239 (UTC) FILETIME=[E7318970:01C78954]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AG1pa2Uuc3Ryb3lhbkBocC5jb20AbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBsaW51eC1pYTY0QHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAHRvbnkubHVja0BpbnRlbC5jb20Abmlja3BpZ2dpbkB5YWhvby5jb20uYXUAcm9oaXRzZXRoQGdvb2dsZS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Nick Piggin wrote:
> 
> OIC, you need a virtual address to evict the icache, so you can't
> flush at flush_dcache time? Or does ia64 have an instruction to
> flush the whole icache? (it would be worth testing, to see how much
> performance suffers).

I'm puzzled by that remark: the ia64 flush_icache_range always has
a virtual address, it uses the kernel virtual address; it takes no
interest in whether there's a user virtual address.

Hugh
