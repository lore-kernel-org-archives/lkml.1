Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZDKTdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZDKTdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZDKTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:33:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39322 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753930AbZDKTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:33:43 -0400
Date: Sat, 11 Apr 2009 20:32:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Implementing NVMHCI...
Message-ID: <20090411203246.513a0892@lxorguk.ukuu.org.uk>
In-Reply-To: <49E0D47B.9070205@garzik.org>
References: <49E0D47B.9070205@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	  The spec describes the sector size as
> 	  "512, 1k, 2k, 4k, 8k, etc."   It will be interesting to reach
> 	  "etc" territory.

Over 4K will be fun.

> - ahci.c becomes a tiny stub with a pci_device_id match table,
>    calling functions in libahci.c.

It needs to a be a little bit bigger because of the folks wanting to do
non PCI AHCI, so you need a little bit of PCI wrapping etc

>    With a brand new command set, might as well avoid SCSI completely IMO,
>    and create a brand new block device.

Providing we allow for the (inevitable ;)) joys of NVHCI over SAS etc 8)


Alan
