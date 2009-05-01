Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbZEAPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbZEAPZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbZEAPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 11:25:05 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:48392 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbZEAPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 11:25:03 -0400
Date: Fri, 1 May 2009 11:14:32 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: alloc_large_system_hash check order
In-Reply-To: <20090501150933.GE27831@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0905011114140.18324@qirst.com>
References: <Pine.LNX.4.64.0904292151350.30874@blonde.anvils> <20090430132544.GB21997@csn.ul.ie> <Pine.LNX.4.64.0905011202530.8513@blonde.anvils> <20090501140015.GA27831@csn.ul.ie> <alpine.DEB.1.10.0905010958090.18324@qirst.com>
 <20090501150933.GE27831@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Mel Gorman wrote:

> But IIRC, the vmemmap code depends on architecture-specific help from
> vmemmap_populate() to place the map in the right place and it's not universally
> available. It's likely that similar would be needed to support large
> hash tables. I think the networking guys would need to be fairly sure
> the larger table would make a big difference before tackling the
> problem.

The same function could be used. Fallback to vmap is always possible.

