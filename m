Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXCUQ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXCUQ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXCUQ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:28:22 -0400
Received: from graphe.net ([209.204.138.32]:54386 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXCUQ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:28:21 -0400
Date: Wed, 21 Mar 2007 09:27:45 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <20070321160929.GB25583@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0703210927130.4934@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
 <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
 <20070321160929.GB25583@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Andi Kleen wrote:

> On Wed, Mar 21, 2007 at 05:42:22PM +0200, Pekka J Enberg wrote:
> > On Wed, 21 Mar 2007, Christoph Lameter wrote:
> > > None of that please. The page flags already contain a node number that is 
> > > accessible via page_to_nid(). Just make sure that we never put a slab onto 
> > > the wrong node.
> > 
> > Oh well, here's a patch to find out. (I don't have a NUMA box.)
> 
> You can always use numa emulation on x86-64.  Boot with numa=fake=NODES

This wont help you to debug strange fallback scenarios on unusual NUMA 
platforms.

