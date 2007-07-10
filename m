Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXGJTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXGJTnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXGJTnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:43:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37184 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755289AbXGJTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:43:39 -0400
Date: Tue, 10 Jul 2007 12:43:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] slub.c:early_kmem_cache_node_alloc() shouldn't be
 __init
In-Reply-To: <20070710190123.GB3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707101243240.12485@schroedinger.engr.sgi.com>
References: <20070710124445.GX3492@stusta.de>
 <Pine.LNX.4.64.0707101132110.11882@schroedinger.engr.sgi.com>
 <20070710190123.GB3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Adrian Bunk wrote:

> But I'm not convinced it's really worth manually forcing noinline only 
> for moving a few bytes to __init in the CONFIG_NUMA=y case - in the  
> long term this will only bit rot.

Allright then

Acked-by: Christoph Lameter <clameter@sgi.com>

