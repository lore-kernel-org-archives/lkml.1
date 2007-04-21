Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXDUHYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXDUHYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbXDUHYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:24:33 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:15424 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbXDUHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:24:32 -0400
X-AuditID: d80ac287-a729dbb000005f82-fd-4629bc3053bd 
Date: Sat, 21 Apr 2007 08:24:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
In-Reply-To: <462932BE.4020005@redhat.com>
Message-ID: <Pine.LNX.4.64.0704210818580.25689@blonde.wat.veritas.com>
References: <46247427.6000902@redhat.com> <20070420135715.f6e8e091.akpm@linux-foundation.org>
 <462932BE.4020005@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Apr 2007 07:24:31.0581 (UTC) FILETIME=[1AA0C8D0:01C783E6]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Rik van Riel wrote:
> Andrew Morton wrote:
> 
> >   I do go on about that.  But we're adding page flags at about one per
> >   year, and when we run out we're screwed - we'll need to grow the
> >   pageframe.
> 
> If you want, I can take a look at folding this into the
> ->mapping pointer.  I can guarantee you it won't be
> pretty, though :)

Please don't.  If we're going to stuff another pageflag into there,
let it be PageSwapCache the natural partner of PageAnon, rather than
whatever our latest pageflag happens to be.  I'll look into it - but
do keep an eye on me, I've developed a dubious track record of
obstructing other people's attempts to save pageflags.

Hugh
