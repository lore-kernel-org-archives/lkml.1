Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXCQOkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXCQOkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965662AbXCQOkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:40:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54597 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965639AbXCQOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:40:18 -0400
Date: Sat, 17 Mar 2007 15:43:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: libata reports bogus addresses for everything (was PATA_PCMCIA  cmd
 port)
Message-ID: <20070317154333.088d77d4@lxorguk.ukuu.org.uk>
In-Reply-To: <20070317220050.380d9f51.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070317220050.380d9f51.komurojun-mbn@nifty.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007 22:00:50 +0900
Komuro <komurojun-mbn@nifty.com> wrote:

> 
> Hi,
>  
> The pata_pcmcia driver reports the cmd port is 0x00010100,
> but actually the cmd port is 0x0100.
> 
> Is this corect?

When the pci_iomap patches were applied the ports reported for every
device went strange.  It appears to display the wrong information
nowdays. I see the same but I've got many more important things to work
on before I even bother to look at it.

My guess is someone is now printing the iomap virtual addresses not the
bus ones.

Alan
