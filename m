Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0BFH1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 02:27:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48454 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0BFH1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 02:27:47 -0500
Date: Sat, 6 Feb 2010 08:27:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, submit@firstfloor.org,
       linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [3/4] SLAB: Separate node initialization into separate function
Message-ID: <20100206072746.GP29555@one.firstfloor.org>
References: <201002031039.710275915@firstfloor.org> <20100203213914.D8654B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051324370.2376@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002051324370.2376@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As Christoph mentioned, this patch is out of order with the previous one 

Ok.

> in the series; slab_node_prepare() is called in that previous patch by a 
> memory hotplug callback without holding cache_chain_mutex (it's taken by 
> the cpu hotplug callback prior to calling cpuup_prepare() currently).  So 
> slab_node_prepare() should note that we require the mutex and the memory 
> hotplug callback should take it in the previous patch.

AFAIK the code is correct. If you feel the need for additional
documentation feel free to send patches yourself.

-Andi
