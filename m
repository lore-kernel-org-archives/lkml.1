Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbYB1XHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbYB1XHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYB1XGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:06:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39896 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757039AbYB1XGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:06:52 -0500
Date: Thu, 28 Feb 2008 22:56:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
Message-ID: <20080228225603.2764bfd1@core>
In-Reply-To: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 23:37:36 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Hi
> 
> just found out that the eSATA connector on my Intel DQ35JO motherboard 
> doesn't work... because it is connected to the controller with product ID 
> 29b6... And this ID is not yet handled by the driver. Can I have a patch, 
> please?:-) I think the correct entry would be

If the device is in AHCI mode it should match the ahci class entry - is
the device in AHCI mode or PIIX mode ?

