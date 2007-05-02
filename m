Return-Path: <linux-kernel-owner+w=401wt.eu-S1767013AbXEBSI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767013AbXEBSI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767053AbXEBSI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:08:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:46012 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767013AbXEBSI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:08:56 -0400
Date: Wed, 2 May 2007 19:08:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705020955550.32271@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705021903320.20615@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705020955550.32271@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 May 2007 18:08:55.0219 (UTC) FILETIME=[F27F0030:01C78CE4]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBjbGFtZXRlckBzZ2kuY29tAGxpbnV4LW1tQGt2YWNrLm9yZwA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Christoph Lameter wrote:
> 
> But these are arch specific problems. We could use 
> ARCH_USES_SLAB_PAGE_STRUCT to disable SLUB on these platforms.

As a quick hack, sure.  But every ARCH_USES_SLAB_PAGE_STRUCT
diminishes the testing SLUB will get.  If the idea is that we're
going to support both SLAB and SLUB, some arches with one, some
with another, some with either, for more than a single release,
then I'm back to saying SLUB is being pushed in too early.
I can understand people wanting pluggable schedulers,
but pluggable slab allocators?

Hugh
