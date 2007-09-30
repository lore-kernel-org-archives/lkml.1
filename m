Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXI3OXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXI3OXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbXI3OXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:23:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46045 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755030AbXI3OXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:23:45 -0400
Date: Sun, 30 Sep 2007 15:29:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20070930152908.1f58d39d@the-village.bc.nu>
In-Reply-To: <20070930160548.235be972@localhost>
References: <20070930160548.235be972@localhost>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 16:05:48 +0200
Paolo Ornati <ornati@fastwebnet.it> wrote:

> Hi, I think you forgot to blacklist this one  :)
> 
> --
> Seagate Barracuda ST380817AS has troubles with NCQ. For example,
> unpacking a tarball on an XFS filesystem gives this:
> 
> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

What makes you sure that is an NCQ problem ?
