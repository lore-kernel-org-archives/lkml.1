Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbYGVMmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbYGVMmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYGVMmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:42:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbYGVMmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:42:11 -0400
Date: Tue, 22 Jul 2008 13:24:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: jgarzik@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8390: Fix ne.c build
Message-ID: <20080722132432.6bae7b02@lxorguk.ukuu.org.uk>
In-Reply-To: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008 23:35:12 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Since commit 055e5110ae0c0c1176a75b78d789294f2ff2f7af ("8390: Split
> 8390 support into a pausing and a non pausing driver core"), ne.c
> cause this build failure:
> 
> drivers/built-in.o: In function `ne_probe1':
> ne.c:(.init.text+0x2464): undefined reference to `NS8390_init'
> drivers/built-in.o: In function `ne_block_output':
> ne.c:(.text.ne_block_output+0x1b0): undefined reference to `NS8390_init'

Yes - I sent the same to Jeff Garzik early July.

Alan
