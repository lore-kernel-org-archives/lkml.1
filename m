Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXFYI5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXFYI5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXFYI4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:56:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50734 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbXFYI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:56:54 -0400
Date: Mon, 25 Jun 2007 10:01:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org,
       davem@davemloft.net, davej@redhat.com
Subject: Re: [PATCH 1/2] [RESEND] PCI: read revision ID by default
Message-ID: <20070625100109.35b4c327@the-village.bc.nu>
In-Reply-To: <20070625031918.4711.2705.stgit@localhost.localdomain>
References: <20070625031918.4711.2705.stgit@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 20:19:18 -0700
Auke Kok <auke-jan.h.kok@intel.com> wrote:

> Currently there are 97 occurrences where drivers need the pci
> revision ID. We can do this once for all devices. Even the pci
> subsystem needs the revision several times for quirks. The extra
> u8 member pads out nicely in the pci_dev struct.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>

Seems worth caching yes. Care needed changing the other uses however
that the revision isn't changeable on the hardware in some magic fashion.

Acked-by: Alan Cox <alan@redhat.com>
