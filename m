Return-Path: <linux-kernel-owner+w=401wt.eu-S935047AbXHHBEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047AbXHHBEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHHBEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:04:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34771 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756617AbXHHBEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:04:21 -0400
Date: Wed, 8 Aug 2007 02:11:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial inter-character timeout usage with async io
Message-ID: <20070808021147.10d0e752@the-village.bc.nu>
In-Reply-To: <46B8F7FE.3090904@3gfp.com>
References: <46B8F7FE.3090904@3gfp.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, I only have this code enabled for i386 and arm, and only for
> the 8250 and pxa serial drivers. If no one thinks this is a terrible
> idea, I'll modify all of the other ioctl.h files and resubmit the patch.

What are you actually trying to achieve ?

Firstly we don't want stuff with deep internal knowledge of devices as
you'll have to modify and test something like 30 device drivers and it
will rapidly be unmaintainable.

