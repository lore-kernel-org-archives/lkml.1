Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbXIZSoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbXIZSoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXIZSoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:44:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49666 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758078AbXIZSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:44:16 -0400
Date: Wed, 26 Sep 2007 11:44:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] LBS: fix uninitialized swapper_space
In-Reply-To: <Pine.LNX.4.64.0709261926060.8443@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709261143240.16457@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0709212144210.13529@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0709241414270.30982@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0709261926060.8443@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007, Hugh Dickins wrote:

> Probably better, yes.  In -mm Peter is doing an #ifdef CONFIG_SWAP
> bdi_init() on swapper_space.  Would make sense to do both together,
> perhaps move them to a swapper_space_init() in swap_state.c, saving
> his #ifdef too.  I suggest leave such cleanups until one or the
> other is mainlined.

Ok. I have updated the largeblock git tree with your patches and a new 
revision of the mmap patches. Still working on it. Fallback in the block 
layer is not yet working. I probably need to look at Nick's patches a bit.

