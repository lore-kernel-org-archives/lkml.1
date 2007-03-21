Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXCUCo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXCUCo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 22:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXCUCo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 22:44:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55138 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXCUCo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 22:44:56 -0400
Date: Wed, 21 Mar 2007 03:44:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <christoph@lameter.com>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;
Message-ID: <20070321024452.GA17532@one.firstfloor.org>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703201716440.17799@graphe.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We usually use page_to_nid(). Sure this will determine the node the object 
> resides on. But this may not be the node on which the slab is tracked 
> since there may have been a fallback at alloc time.

How about your slab rewrite?  I assume it would make more sense to fix
such problems in that code instead of the old which is going to be replaced
at some point.

-Andi
> 
