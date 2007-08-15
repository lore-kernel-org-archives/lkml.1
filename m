Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXHOJ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXHOJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbXHOJ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:59:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39590 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbXHOJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:59:19 -0400
Date: Wed, 15 Aug 2007 11:06:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH take #5] [libata] libata driver for bf548 on chip ATAPI
 controller.
Message-ID: <20070815110654.360cc210@the-village.bc.nu>
In-Reply-To: <1187169256.31383.3.camel@sevens.analog.com>
References: <1187169256.31383.3.camel@sevens.analog.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007 17:14:15 +0800
Sonic Zhang <sonic.adi@gmail.com> wrote:

> Update:
> 1. Condition branch code instead of while loop from Alan Cox.
> 2. Condtinue in PIO mode after failing to request DMA.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Alan Cox <alan@redhat.com>


Minor stuff like consts can go in later as a tidy up. Also the big chunk
of work to improve this driver (removing a lot of shared reset/probe
code) needs libata changes and will be easier to do after not before merge
