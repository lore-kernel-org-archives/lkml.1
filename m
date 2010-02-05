Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab0BETOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 14:14:07 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42194 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab0BETOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 14:14:06 -0500
Date: Fri, 5 Feb 2010 13:12:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: [PATCH] [2/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory
In-Reply-To: <20100203213913.D5CD4B1620@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002051311530.25989@router.home>
References: <201002031039.710275915@firstfloor.org> <20100203213913.D5CD4B1620@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Andi Kleen wrote:

> Requires previous refactor patch.

Not in this series?

> +	if (action == MEM_ONLINE && mn->status_change_nid >= 0)
> +		slab_node_prepare(mn->status_change_nid);
> +	return NOTIFY_OK;

Never seen a slab_node_prepare function before.
