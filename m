Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZLWKXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZLWKXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZLWKXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:23:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749AbZLWKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:23:44 -0500
Date: Wed, 23 Dec 2009 11:23:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: initialize unused alien cache entry as NULL at
	alloc_alien_cache().
Message-ID: <20091223102343.GD20539@basil.fritz.box>
References: <4B30BDA8.1070904@linux.intel.com> <alpine.DEB.2.00.0912220945250.12048@router.home> <4B31BE44.1070308@linux.intel.com> <4B31EC7C.7000302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31EC7C.7000302@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Then, this is a violation of the first statement :
> 
> nr_node_ids = 1 + nid of highest POSSIBLE node.
> 
> If your system allows hotplugging of new nodes, then POSSIBLE nodes should include them
> at boot time.

Agreed, nr_node_ids must be possible nodes.

It should have been set up by the SRAT parser (modulo regressions)

Haicheng, did you verify with printk it's really incorrect at this point?
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
