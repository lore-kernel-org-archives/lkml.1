Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZBXRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZBXRdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZBXRdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:33:20 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:41735 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759421AbZBXRdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:33:19 -0500
Date: Tue, 24 Feb 2009 12:24:28 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 06/19] Check only once if the zonelist is suitable for
 the allocation
In-Reply-To: <1235477835-14500-7-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902241220300.32227@qirst.com>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie> <1235477835-14500-7-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Mel Gorman wrote:

> It is possible with __GFP_THISNODE that no zones are suitable. This
> patch makes sure the check is only made once.

GFP_THISNODE is only a performance factor if SLAB is the slab allocator.
The restart logic in __alloc_pages_internal() is mainly used by OOM
processing.

But the patch looks okay regardless...

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
