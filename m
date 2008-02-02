Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbYBBUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbYBBUF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBBUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:05:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:59844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYBBUFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:05:51 -0500
Date: Sat, 2 Feb 2008 12:02:01 -0800
From: Greg KH <gregkh@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: ACPI problem on PowerPC
Message-ID: <20080202200201.GA24717@suse.de>
References: <1201958684.15090.42.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201958684.15090.42.camel@violet>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 02:24:44PM +0100, Marcel Holtmann wrote:
> Hi Greg,
> 
> the following happens with the latest ACPI and PCI merges on my Quad G5:
> 
>   CC      drivers/pci/pcie/aspm.o
> In file included from include/acpi/platform/acenv.h:140,
>                  from include/acpi/acpi.h:54,
>                  from include/acpi/acpi_bus.h:31,
>                  from drivers/pci/pcie/aspm.c:20:
> include/acpi/platform/aclinux.h:59:22: error: asm/acpi.h: No such file or directory
> In file included from include/acpi/platform/aclinux.h:120,
>                  from include/acpi/platform/acenv.h:140,
>                  from include/acpi/acpi.h:54,
>                  from include/acpi/acpi_bus.h:31,
>                  from drivers/pci/pcie/aspm.c:20:
> include/acpi/actypes.h:130: error: expected ???=???, ???,???, ???;???, ???asm??? or ???__attribute__??? before ???UINT64???
> include/acpi/actypes.h:131: error: expected ???=???, ???,???, ???;???, ???asm??? or ???__attribute__??? before ???INT64???
> include/acpi/actypes.h:753: error: expected ???)??? before ???*??? token
> include/acpi/actypes.h:756: error: expected ???)??? before ???*??? token
> In file included from include/acpi/acpi.h:61,
>                  from include/acpi/acpi_bus.h:31,
>                  from drivers/pci/pcie/aspm.c:20:
> include/acpi/acpiosxf.h:178: error: expected declaration specifiers or ???...??? before ???acpi_osd_handler???
> include/acpi/acpiosxf.h:182: error: expected declaration specifiers or ???...??? before ???acpi_osd_handler???
> include/acpi/acpiosxf.h:191: error: expected declaration specifiers or ???...??? before ???acpi_osd_exec_callback???
> make[3]: *** [drivers/pci/pcie/aspm.o] Error 1
> make[2]: *** [drivers/pci/pcie] Error 2
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2
> 
> The Quad G5 has PCI Express, but I am not sure about the ASPM support.
> Obviously I enabled CONFIG_PCIEASPM.

Yeah, bad merge, I'm reverting that change, it is wrong...

thanks,

greg k-h
