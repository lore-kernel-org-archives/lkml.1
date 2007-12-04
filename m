Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXLDVHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXLDVHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXLDVGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:06:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbXLDVGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:06:32 -0500
Date: Tue, 4 Dec 2007 21:02:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
Message-ID: <20071204210202.7f9c513c@the-village.bc.nu>
In-Reply-To: <4755BE04.8030909@garzik.org>
References: <47548BF4.3010907@nortel.com>
	<20071203230629.725f4c7a@the-village.bc.nu>
	<4755BE04.8030909@garzik.org>
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

On Tue, 04 Dec 2007 15:52:20 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> > For things like SATA based devices they aren't that fast yet. 
> 
> You forget the Gigabyte i-RAM.
> 
> For others:  the i-RAM is a SATA-based device that plugs into a PCI slot 
> on your motherboard (for power), providing RAM+battery backup as fast as 
> your SATA bus and DIMMs will go.

Actually even allowing for the iRAM the SATA stuff is way too slow to be
worth using synchronously. The latency is a killer.
