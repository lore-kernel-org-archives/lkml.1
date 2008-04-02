Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYDBKyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYDBKyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYDBKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:54:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58228 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYDBKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:54:28 -0400
Date: Wed, 2 Apr 2008 13:54:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: paulmck@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
In-Reply-To: <1207133344.8514.759.camel@twins>
Message-ID: <Pine.LNX.4.64.0804021353380.31276@sbz-30.cs.Helsinki.FI>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> 
 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> 
 <20080402104025.GC2813@linux.vnet.ibm.com> 
 <84144f020804020346v6c6de91fr795dec55e0543105@mail.gmail.com>
 <1207133344.8514.759.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Peter Zijlstra wrote:
> Correct, that is always how i understood SLAB_DESTROY_BY_RCU to work.
> 
> Does SLAB (as opposed to SLUB) do it differently?

No, SLAB works this way as well.

			Pekka
