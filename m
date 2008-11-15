Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbYKOJaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbYKOJaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 04:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYKOJaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 04:30:00 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42185 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbYKOJ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 04:29:58 -0500
Date: Sat, 15 Nov 2008 09:28:37 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
In-Reply-To: <491DBD9E.6030703@goop.org>
Message-ID: <Pine.LNX.4.64.0811150914080.16789@blonde.site>
References: <491C61B1.10005@goop.org> <200811141417.35724.nickpiggin@yahoo.com.au>
 <491D0B2F.7050900@goop.org> <200811141835.17073.nickpiggin@yahoo.com.au>
 <491DBD9E.6030703@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > No, adding a cycle here or an indirect function call there IMO is
> > not acceptable in core mm/ code without a good reason.
> 
> <shrug> OK.

I'm with Nick on this: admittedly remap_pfn_range() is a borderline
case (since it has no latency breaks at present), but it is a core
mm function, and I'd prefer we leave it as is unless good reason.

So, no hurry, but I'd prefer 

mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-remap_pfn_range-restore-missing-flush.patch

to be removed from mmotm - and don't I deserve that,
just for actually reading the mm-commits boilerplate ;-?

Hugh
