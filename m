Return-Path: <linux-kernel-owner+w=401wt.eu-S934791AbYETW1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791AbYETW1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762111AbYETW1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:27:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44566 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932668AbYETW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:27:35 -0400
Date: Tue, 20 May 2008 23:15:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott Wood <scottwood@freescale.com>
Cc: benh@kernel.crashing.org, Trent Piepho <tpiepho@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
Message-ID: <20080520231516.76b924a2@core>
In-Reply-To: <483344C0.3020703@freescale.com>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	<1211318219.8297.177.camel@pasglop>
	<483344C0.3020703@freescale.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like we rely on -fno-strict-aliasing to prevent reordering 
> ordinary memory accesses (such as to DMA descriptors) past the I/O 

DMA descriptors in main memory are dependant on cache behaviour anyway
and the dma_* operators should be the ones enforcing the needed behaviour.

Alan
