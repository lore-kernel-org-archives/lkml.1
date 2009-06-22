Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZFVPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZFVPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZFVPbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:31:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFVPbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:31:02 -0400
Date: Mon, 22 Jun 2009 16:29:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090622152919.GA29188@n2100.arm.linux.org.uk>
References: <20090622140807.25509.54448.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622140807.25509.54448.stgit@bob.kio>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 08:08:07AM -0600, Alex Chiang wrote:
> This was #define'd as 0 on all platforms, so let's get rid of it.
> 
> This change makes pci_scan_slot() slightly easier to read.
> 
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

For:

> diff --git a/arch/arm/include/asm/pci.h b/arch/arm/include/asm/pci.h
> index 0abf386..226cddd 100644
> --- a/arch/arm/include/asm/pci.h
> +++ b/arch/arm/include/asm/pci.h
> @@ -6,8 +6,6 @@
>  
>  #include <mach/hardware.h> /* for PCIBIOS_MIN_* */
>  
> -#define pcibios_scan_all_fns(a, b)	0
> -
>  #ifdef CONFIG_PCI_HOST_ITE8152
>  /* ITE bridge requires setting latency timer to avoid early bus access
>     termination by PIC bus mater devices

Thanks.
