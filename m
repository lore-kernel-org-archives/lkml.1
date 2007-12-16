Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXLPUXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXLPUXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 15:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbXLPUXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 15:23:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59044 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753944AbXLPUXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 15:23:17 -0500
Date: Sun, 16 Dec 2007 20:16:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Joa <oliver@j-o-a.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
Message-ID: <20071216201643.396fa8d7@the-village.bc.nu>
In-Reply-To: <4765690C.6010605@j-o-a.de>
References: <4765690C.6010605@j-o-a.de>
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

On Sun, 16 Dec 2007 19:06:04 +0100
Oliver Joa <oliver@j-o-a.de> wrote:

> Hi,
> 
> how can I tell the kernel not to probe DMA for a specific harddisk (e.g. 
> hda). My first Drive (hda) is a Compact-Flash Card which can not do DMA. 
> The kernel tries at boot to switch to DMA but fails. If I use ide=nodma, 
> the kernel boots about 2 minutes faster, but then I can not switch on 
> DMA for the second Drive (hdc) which is a normal Harddisk. Do I have to 
> live with this 2 minutes waiting time or is there another solution? I 
> did not find any kernel-parameter for this purpose.
> 
> Sorry if I ask here, but I can not find any solution, and I asked 
> already in other groups.

For the current kernel and libata you can use libata.dma=3, and it will
select DMA for disk (1) + CD (2) but not CF cards. With the older IDE it
should be sufficient to use hda=nodma

Alan
