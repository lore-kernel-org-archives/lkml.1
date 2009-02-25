Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZBYMjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZBYMjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZBYMjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:39:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35848 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZBYMjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:39:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200902250452.UAA12902@hpdst41.cup.hp.com>
References: <200902250452.UAA12902@hpdst41.cup.hp.com>
To: Justin Chen <jchen@hpdst41.cup.hp.com>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org, bjorn.helgaas@hp.com,
       justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] bitops: Change the bitmap index from int to unsigned long [frv]
Date: Wed, 25 Feb 2009 12:37:10 +0000
Message-ID: <16693.1235565430@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Chen <jchen@hpdst41.cup.hp.com> wrote:

> Change the index to unsigned long in all bitops for [frv]
> 
> Signed-off-by: Justin Chen <justin.chen@hp.com>
> Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Mostly okay, apart from:

> -static inline int __constant_test_bit(int nr, const volatile void * addr)
> +static inline int
> +__constant_test_bit(unsigned long nr, const volatile void *addr)

Please move the return type onto the next line also.  Other than that:

Acked-by: David Howells <dhowells@redhat.com>
