Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153AbXFYJBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbXFYJBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbXFYJAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:00:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52510 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbXFYJAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:00:51 -0400
Date: Mon, 25 Jun 2007 10:04:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       davem@davemloft.net, davej@redhat.com
Subject: Re: [PATCH 2/2] [RESEND] PCI: Change all drivers to use
 pci_device->revision
Message-ID: <20070625100447.1b3ae35e@the-village.bc.nu>
In-Reply-To: <20070625031929.4711.79012.stgit@localhost.localdomain>
References: <20070625031918.4711.2705.stgit@localhost.localdomain>
	<20070625031929.4711.79012.stgit@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 20:19:29 -0700
Auke Kok <auke-jan.h.kok@intel.com> wrote:

> Instead of all drivers reading pci config space to get the revision
> ID, they can now use the pci_device->revision member.
> 
> This exposes some issues where drivers where reading a word or a dword
> for the revision number, and adding useless error-handling around the
> read. Some drivers even just read it for no purpose of all.
> 
> In devices where the revision ID is being copied over and used in what
> appears to be the equivalent of hotpath, I have left the copy code
> and the cached copy as not to influence the driver's performance.
> 
> Compile tested with make all{yes,mod}config on x86_64 and i386.

Ack the drivers/ata part but please split this up per subsystem and send
the chunks to the subsystem maintainers.

Alan
