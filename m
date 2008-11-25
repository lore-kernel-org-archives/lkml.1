Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYKYS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYKYS7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYKYS7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:59:03 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:39812 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYKYS7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:59:01 -0500
Date: Tue, 25 Nov 2008 12:58:27 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
       david@fromorbit.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slab: __GFP_NOWARN not being propagated from
 mempool_alloc()
In-Reply-To: <Pine.LNX.4.64.0811250038030.11825@melkki.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0811251258010.18908@quilx.com>
References: <E1L4jMt-0006OW-5J@pomaz-ex.szeredi.hu>
 <Pine.LNX.4.64.0811250038030.11825@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Pekka J Enberg wrote:

> Yes, it does but looking at mm/slab.c history I think we want something
> like the following instead. Christoph?

Right.
