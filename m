Return-Path: <linux-kernel-owner+w=401wt.eu-S1759760AbYB0U1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbYB0U1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYB0U0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:26:50 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757212AbYB0U0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:26:49 -0500
Date: Wed, 27 Feb 2008 12:24:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: dada1@cosmosbay.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yanmin_zhang@linux.intel.com, travis@sgi.com
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
Message-Id: <20080227122451.6a3b5565.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802271158100.1790@schroedinger.engr.sgi.com>
References: <47BDBC23.10605@cosmosbay.com>
	<Pine.LNX.4.64.0802271158100.1790@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 11:59:32 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> Any decision made on what to do about this one? Mike or I can 
> repost the per cpu allocator against mm? The fix by Eric could be used 
> in the interim for 2.6.24?
> 

I suppose I'll merge Eric's patch when I've tested it fully (well, as fully
as I test stuff).

It'd be nice to get that cache_line_size()/L1_CACHE_BYTES/L1_CACHE_ALIGN()
mess sorted out.  If it's a mess - I _think_ it is?


