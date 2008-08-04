Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYHDQgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYHDQgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYHDQgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:36:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYHDQgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:36:39 -0400
Message-ID: <48972FBF.9040100@linux-foundation.org>
Date: Mon, 04 Aug 2008 11:35:11 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <48970779.80902@linux-foundation.org> <20080804144823.GE18868@shareable.org> <20080804152146.GG18868@shareable.org>
In-Reply-To: <20080804152146.GG18868@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:

> The different behaviours of SLAB/SLUB might result in different levels
> of fragmentation, so I wonder if anyone has compared them on MMU-less
> systems or fragmentation-sensitive workloads on general systems.

Never heard of such a comparison.

MMU less systems typically have a minimal number of processors. For that
configuration the page orders are roughly equivalent to slab. Larger orders
come into play with large amounts of processors.
