Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYFMMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYFMMF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 08:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYFMMFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 08:05:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYFMMFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 08:05:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080612221131.GO17231@cs181133002.pp.htv.fi>
References: <20080612221131.GO17231@cs181133002.pp.htv.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] mn10300: move sg_dma_{address,len}() to asm/scatterlist.h
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 13 Jun 2008 13:04:44 +0100
Message-ID: <27455.1213358684@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> mn10300 was the only archotecture where sg_dma_{address,len}() were not 
> in asm/scatterlist.h, and it's not a big surprise that this caused a 
> compile error somewhere:
> 
> <--  snip  -->
> 
> ..
>   CC      drivers/media/video/videobuf-dma-sg.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c: In function `videobuf_dma_map':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/media/video/videobuf-dma-sg.c:238: error: implicit declaration of function 'sg_dma_address'
> ...
> make[4]: *** [drivers/media/video/videobuf-dma-sg.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David Howells <dhowells@redhat.com>
