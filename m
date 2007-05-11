Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXEKAvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXEKAvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXEKAvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:51:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35049 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756647AbXEKAvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:51:07 -0400
Date: Fri, 11 May 2007 01:55:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Mark Lord <liml@rtr.ca>,
       Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
Message-ID: <20070511015512.611352ac@the-village.bc.nu>
In-Reply-To: <4643AF19.5080309@garzik.org>
References: <46428103.3040003@shaw.ca>
	<4642E92D.5010509@gmail.com>
	<46431D19.1070308@rtr.ca>
	<46434AE5.8060605@garzik.org>
	<46438FAC.1030702@rtr.ca>
	<464391B3.7040708@garzik.org>
	<4643AB76.1000408@shaw.ca>
	<4643AF19.5080309@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Scrollback rarely works as planned, for me.  Overall, a balance must be 
> found.
> 
> More information is more helpful.  But.
> 
> There are downsides to spewing everything possible, upon error.  You 
> cause logging to the possibly problematic disk, you push older messages 
> out of the printk ring buffer, etc., etc.

Get yourself a Voodoo5 or similar card cheap off ebay. The firmware on
most of them doesn't clear the top 30MB of RAM on a reboot/PCI reset
which makes them excellent debug buffers providing you empty the buffer
before you run the X server.

Alan
