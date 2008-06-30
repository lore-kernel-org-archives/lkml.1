Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbYF3KCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbYF3KCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYF3KBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:01:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34494 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755167AbYF3KBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:01:53 -0400
Date: Mon, 30 Jun 2008 10:44:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Subject: Re: [PATCH 13/13] viafb: via_utility.c, via_utility.h, vt1636.c,
 vt1636.h
Message-ID: <20080630104407.6adf59ab@lxorguk.ukuu.org.uk>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E78BE@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E78BE@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void get_gamma_table(unsigned int *gamma_table)

Still more globals with names asking to cause clashes

> +{
> +	unsigned char color_r[256];
> +	unsigned char color_g[256];
> +	unsigned char color_b[256];
> +	unsigned char sr1a = 0;

and possibly excesive stack usage


I think at this point however the code is in a state where it would be
more productive to merge it and then fix up the remaining smaller details
than keep going round back to VIA to change it internally and return.

So

Acked-by: Alan Cox <alan@redhat.com>  - for the patch series, subject to
further tidyups getting done after it is all merged.

Alan
