Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXCUQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXCUQJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbXCUQJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:09:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43995 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710AbXCUQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:09:31 -0400
Date: Wed, 21 Mar 2007 17:09:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <christoph@lameter.com>,
       Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of struct slab
Message-ID: <20070321160929.GB25583@one.firstfloor.org>
References: <20070321102231.7288f231.dada1@cosmosbay.com> <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com> <Pine.LNX.4.64.0703210742080.1573@graphe.net> <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 05:42:22PM +0200, Pekka J Enberg wrote:
> On Wed, 21 Mar 2007, Christoph Lameter wrote:
> > None of that please. The page flags already contain a node number that is 
> > accessible via page_to_nid(). Just make sure that we never put a slab onto 
> > the wrong node.
> 
> Oh well, here's a patch to find out. (I don't have a NUMA box.)

You can always use numa emulation on x86-64.  Boot with numa=fake=NODES

-Andi
