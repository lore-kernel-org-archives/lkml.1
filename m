Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbXJXVLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbXJXVLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXJXVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:11:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33149 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753970AbXJXVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:11:08 -0400
Date: Wed, 24 Oct 2007 22:13:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: nick@ukfsn.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: New CD/DVD drive - 80-wire cable detection failure
Message-ID: <20071024221353.2117fd76@the-village.bc.nu>
In-Reply-To: <200710241803.03955.nick@ukfsn.org>
References: <200710181832.42906.nick@ukfsn.org>
	<200710201322.57178.nick@ukfsn.org>
	<200710240133.08425.bzolnier@gmail.com>
	<200710241803.03955.nick@ukfsn.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> hdd: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache<7>hdd: skipping 
> word 93 validity check
> , UDMA(66)
> 
> 
> Many thanks indeed!

Sigh I'd hoped that libata could avoid the word 93 mess but apparently
not. Bartlomiej - I've ported your IVB bits over into libata as a new
horkage type.

Alan
