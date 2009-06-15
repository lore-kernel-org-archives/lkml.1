Return-Path: <linux-kernel-owner+w=401wt.eu-S936001AbZFOW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936001AbZFOW1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZFOW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:27:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbZFOW1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:27:11 -0400
Date: Mon, 15 Jun 2009 15:26:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: zygo.blaxell@xandros.com, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH] LIB: remove unmatched write_lock() in gen_pool_destroy
Message-Id: <20090615152608.7f4f6548.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>
References: <E1MGFiZ-0006oN-UW@dactyl.ottawa.xandros.ca>
	<alpine.LNX.2.00.0906152333080.7457@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 23:35:31 +0200 (CEST)
Jiri Kosina <trivial@kernel.org> wrote:

> > -	write_lock(&pool->lock);
> >  	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
> >  		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
> >  		list_del(&chunk->next_chunk);
> > -- 
> > 1.5.6.5
> > 
> 
> Hi Zygo,
> 
> this doesn't really qualify for trivial tree, as it introduces a 
> significant code change. Adding some CCs.

yep, I merged it, thanks.

I wonder why drivers/infiniband/hw/cxgb3 users never noticed this.

