Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0BSIxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 03:53:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab0BSIxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 03:53:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100219131335E.fujita.tomonori@lab.ntt.co.jp>
References: <20100219131335E.fujita.tomonori@lab.ntt.co.jp> <20100212145830I.fujita.tomonori@lab.ntt.co.jp> <28355.1266401022@redhat.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] frv: remove the obsolete and unnecessary DMA API comments
Date: Fri, 19 Feb 2010 08:52:52 +0000
Message-ID: <20943.1266569572@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> +/*
> + * See Documentation/DMA-API.txt for the description of how the
> + * following DMA API should work.
> + */
> +
>  #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
>  #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)

Yep, that'd do.  And for MN10300.

David
