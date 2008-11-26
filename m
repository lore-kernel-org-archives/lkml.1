Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYKZIIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYKZIIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKZIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:08:41 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33956 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYKZIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:08:40 -0500
Subject: Re: [RFC PATCH] slab: __GFP_NOWARN not being propagated from
	mempool_alloc()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
       david@fromorbit.com, peterz@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0811251258010.18908@quilx.com>
References: <E1L4jMt-0006OW-5J@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0811250038030.11825@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0811251258010.18908@quilx.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Nov 2008 10:10:21 +0200
Message-Id: <1227687021.31128.3.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Pekka J Enberg wrote:
> > Yes, it does but looking at mm/slab.c history I think we want something
> > like the following instead. Christoph?

﻿On Tue, 2008-11-25 at 12:58 -0600, Christoph Lameter wrote:
> Right.

OK, even though no tester showed up, I went ahead and merged my version
of the patch as it's a pretty obvious one-liner fix.

