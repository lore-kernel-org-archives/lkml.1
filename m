Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXLAVZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXLAVZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbXLAVZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:25:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48010 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191AbXLAVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:25:47 -0500
Date: Sat, 1 Dec 2007 21:21:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [bug] cops/atalk hung bootup with 2.6.23-rc4
Message-ID: <20071201212121.39bf425f@the-village.bc.nu>
In-Reply-To: <20071201210322.GA9080@elte.hu>
References: <20071201210322.GA9080@elte.hu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and a hung bootup. Config and bootlog attached. I guess the core problem 
> is that somehow the the cops driver got registered to IRQ5:
> 
> [   23.067416] lt0: cops at 0x240, IRQ 5, in Tangent mode
> 
> is this an old ISA driver perhaps that should i exclude from this 
> randconfig testing?

Its an ISA driver for localtalk so yes I would exclude it.

