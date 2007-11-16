Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbXKPXvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbXKPXvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761670AbXKPXvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:51:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57919 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761028AbXKPXvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:51:31 -0500
Date: Fri, 16 Nov 2007 23:49:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NR_OPEN should be raised a litle bit
Message-ID: <20071116234902.75fdef5c@the-village.bc.nu>
In-Reply-To: <473E1144.9070404@cosmosbay.com>
References: <473E1144.9070404@cosmosbay.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007 22:53:08 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Time has come to change NR_OPEN value, some production servers hit the
> not so 'ridiculously high value' of 1024*1024 file descriptors per process.

Why fiddle with the kernel defaults when every distribution can manage
this in user space - including picking defaults by memory size or
platform ?
