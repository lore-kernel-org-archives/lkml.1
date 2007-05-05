Return-Path: <linux-kernel-owner+w=401wt.eu-S1423163AbXEEPju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423163AbXEEPju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422991AbXEEPjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:39:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423083AbXEEPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:39:20 -0400
Date: Sat, 5 May 2007 08:39:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 0/3] Slab Defrag / Slab Targeted Reclaim and general Slab
 API changes
In-Reply-To: <463C1900.7060409@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705050835480.26574@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <463C10F8.4040803@cosmosbay.com>
 <Pine.LNX.4.64.0705042209050.14211@schroedinger.engr.sgi.com>
 <463C1900.7060409@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007, Eric Dumazet wrote:

> > Then add ___cacheline_aligned_in_smp or specify the alignment in the various
> > other ways that exist. Practice is that most slabs specify
> > SLAB_HWCACHE_ALIGN. So most slabs are cache aligned today.
> 
> Yes but this alignement is dynamic, not at compile time.
> 
> include/asm-i386/processor.h:739:#define cache_line_size()
> (boot_cpu_data.x86_cache_alignment)

Ahh.. I did not see that before.

> So adding ____cacheline_aligned  to 'struct file' for example would be a
> regression for people with PII or PIII

Yuck.

