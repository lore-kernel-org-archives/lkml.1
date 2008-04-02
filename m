Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbYDBRik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbYDBRik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYDBRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:38:31 -0400
Received: from relay1.sgi.com ([192.48.171.29]:32856 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755276AbYDBRia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:38:30 -0400
Date: Wed, 2 Apr 2008 10:35:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
In-Reply-To: <1207133344.8514.759.camel@twins>
Message-ID: <Pine.LNX.4.64.0804021035481.26938@schroedinger.engr.sgi.com>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> 
 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> 
 <20080402104025.GC2813@linux.vnet.ibm.com> 
 <84144f020804020346v6c6de91fr795dec55e0543105@mail.gmail.com>
 <1207133344.8514.759.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Peter Zijlstra wrote:

> Does SLAB (as opposed to SLUB) do it differently?

No it works the same in both.

