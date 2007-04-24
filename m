Return-Path: <linux-kernel-owner+w=401wt.eu-S1422861AbXDXRpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422861AbXDXRpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422863AbXDXRpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:45:03 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37289 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422881AbXDXRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:45:00 -0400
Date: Tue, 24 Apr 2007 10:45:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> I've not yet looked at the patch under discussion, but this remark
> prompts me...  a couple of days ago I got very worried by the various
> hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> and wondered how those would work out if someone has a blockdev mmap'ed.

I hope you are not confused by the fact that memory policies are only
ever applied to one zone on a node. This is either HIGHMEM or NORMAL. 
There is no memory policy support for other than the highest zone.

