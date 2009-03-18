Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZCRTLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZCRTLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbZCRTKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:10:48 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:48506 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbZCRTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:10:47 -0400
Date: Wed, 18 Mar 2009 15:07:48 -0400 (EDT)
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
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of precalculated
 values
In-Reply-To: <20090318181717.GC24462@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903181507120.10154@qirst.com>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie> <1237226020-14057-25-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161500280.20024@qirst.com> <20090318135222.GA4629@csn.ul.ie> <alpine.DEB.1.10.0903181011210.7901@qirst.com>
 <20090318153508.GA24462@csn.ul.ie> <alpine.DEB.1.10.0903181300540.15570@qirst.com> <20090318181717.GC24462@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Mel Gorman wrote:

> Thanks.At a quick glance, it looks ok but I haven't tested it. As the intention
> was to get one pass of patches that are not controversial and are "obvious",
> I have dropped my version of the gfp_zone patch and the subsequent flag
> cleanup and will revisit it after the first lot of patches has been dealt
> with. I'm testing again with the remaining patches.

This fixes buggy behavior of gfp_zone so it would deserve a higher
priority.


