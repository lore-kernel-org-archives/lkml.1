Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXFKTQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXFKTQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXFKTP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:15:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58159 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbXFKTP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:15:56 -0400
Date: Mon, 11 Jun 2007 20:17:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
Message-ID: <20070611201716.3ab98187@the-village.bc.nu>
In-Reply-To: <20070611184621.GA25371@redhat.com>
References: <466D550C.4030600@shadowen.org>
	<63a08cc7547f14065becdf9a94d0d529@pinky>
	<20070611091558.f468f205.akpm@linux-foundation.org>
	<20070611172006.GI9174@redhat.com>
	<466D882D.70001@zytor.com>
	<Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
	<20070611184621.GA25371@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do such beasts even exist ?  My memories of low-memory x86en I had
> only allowed power of 2 memory sizes.

They existed. If you had two memory banks you could load 4MB and 1MB. If
you had a single set of memory sockets then you got powers of two
