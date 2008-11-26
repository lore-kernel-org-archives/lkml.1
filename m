Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbYKZJuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbYKZJuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYKZJuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:50:37 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41600 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYKZJug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:50:36 -0500
To: penberg@cs.helsinki.fi
CC: cl@linux-foundation.org, miklos@szeredi.hu, linux-mm@kvack.org,
       david@fromorbit.com, peterz@infradead.org, linux-kernel@vger.kernel.org
In-reply-to: <1227687021.31128.3.camel@penberg-laptop> (message from Pekka
	Enberg on Wed, 26 Nov 2008 10:10:21 +0200)
Subject: Re: [RFC PATCH] slab: __GFP_NOWARN not being propagated from
	mempool_alloc()
References: <E1L4jMt-0006OW-5J@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0811250038030.11825@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0811251258010.18908@quilx.com> <1227687021.31128.3.camel@penberg-laptop>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1L5H2E-0001Ro-Da@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Nov 2008 10:50:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Pekka Enberg wrote:
> On Tue, 25 Nov 2008, Pekka J Enberg wrote:
> > > Yes, it does but looking at mm/slab.c history I think we want something
> > > like the following instead. Christoph?
> 
> ﻿On Tue, 2008-11-25 at 12:58 -0600, Christoph Lameter wrote:
> > Right.
> 
> OK, even though no tester showed up, I went ahead and merged my version
> of the patch as it's a pretty obvious one-liner fix.

Thanks.  I merged your version in the suse tree as well, so there'll
be lots of testers :)

Miklos
