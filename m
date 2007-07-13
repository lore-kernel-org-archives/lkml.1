Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXGMPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXGMPGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761017AbXGMPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:06:06 -0400
Received: from [81.2.110.250] ([81.2.110.250]:42699 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760320AbXGMPGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:06:05 -0400
Date: Fri, 13 Jul 2007 16:12:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Piotr Muszynski <piotr@itg.hitachi.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: REQUEST_SENSE and ide-cd.c
Message-ID: <20070713161227.6d4a572b@the-village.bc.nu>
In-Reply-To: <46949541.4040206@itg.hitachi.co.jp>
References: <46949541.4040206@itg.hitachi.co.jp>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 17:30:57 +0900
Piotr Muszynski <piotr@itg.hitachi.co.jp> wrote:

> I am adding transparent ATAPI capability to USB gadget Mass Storage 
> driver. The idea is to pass USB traffic to block device queue as packet 
> requests. At the end of the queue, the requests are handled by ide-cd.c 
> driver.

Work with the libata translation code and SCSI stack as ide-cd is really
on its way out now. Libata is essentally doing all the SCSI to ATA/ATAPI
translation work you should need.

Alan
