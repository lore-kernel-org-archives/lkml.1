Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbXHBNsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbXHBNsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbXHBNsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:48:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59502 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXHBNsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:48:01 -0400
Subject: Re: [PATCH] type safe allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
In-Reply-To: <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
	 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu>
	 <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 15:47:56 +0200
Message-Id: <1186062476.12034.115.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 16:04 +0400, Alexey Dobriyan wrote:
> On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > The linux kernel doesn't have a type safe object allocator a-la new()
> > in C++ or g_new() in glib.
> >
> > Introduce two helpers for this purpose:
> >
> >    alloc_struct(type, gfp_flags);
> >
> >    zalloc_struct(type, gfp_flags);
> 
> ick.
> 
> > These macros take a type name (usually a 'struct foo') as first
> > argument
> 
> So one has to type struct twice.

thrice in some cases like alloc_struct(struct task_struct, GFP_KERNEL)

I've always found this _struct postfix a little daft, perhaps its time
to let the janitors clean that out?


