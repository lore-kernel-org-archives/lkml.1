Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbXCUOnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbXCUOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXCUOnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:43:08 -0400
Received: from graphe.net ([209.204.138.32]:56774 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbXCUOnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:43:06 -0400
Date: Wed, 21 Mar 2007 07:42:51 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703210742080.1573@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 Mar 2007, Pekka Enberg wrote:

> Can we please have a slab_get_nid() and slab_set_nid() instead which
> reduces the need for #ifdefs?

None of that please. The page flags already contain a node number that is 
accessible via page_to_nid(). Just make sure that we never put a slab onto 
the wrong node.

