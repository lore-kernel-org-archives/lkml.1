Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbYAaPtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbYAaPtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYAaPti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:49:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:31504 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453AbYAaPtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:49:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:message-id;
        b=oSqmd6J1VvpFT9kLns6QhiR/4dQUbl7LavhbtYGtO4yR+wmiWwpUlt93/vZgulK+idUjYoKXg5tbWpeYT+uwzH0wkg11KMtTLuZhxTuxpJwJHyDxmnnoXHRGZfoHU3IFDC+WBAibEmkWWseG70EYjWcFsvW/pwZv217wb0z4Hyw=
From: Alessandro Guido <alessandro.guido@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Misc warnings during kernel build
Date: Thu, 31 Jan 2008 16:48:43 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_b3eoHXkOKAYFBc7"
Message-Id: <200801311648.43389.alessandro.guido@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_b3eoHXkOKAYFBc7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Kconfig:

drivers/net/Kconfig:1743:warning: 'select' used by config symbol 'CPMAC' 
refers to undefined symbol 'FIXED_MII_100_FDX'
drivers/spi/Kconfig:156:warning: 'select' used by config symbol 'SPI_PXA2XX' 
refers to undefined symbol 'PXA_SSP'


Section mismatches:

WARNING: drivers/ata/built-in.o(.text+0x15b75): Section mismatch in reference 
from the function piix_init_one() to the 
function .devinit.text:piix_check_450nx_errata()
The function  piix_init_one() references
the function __devinit piix_check_450nx_errata().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_check_450nx_errata is wrong.

WARNING: drivers/ata/built-in.o(.text+0x15c11): Section mismatch in reference 
from the function piix_init_one() to the 
function .devinit.text:piix_init_sata_map()
The function  piix_init_one() references
the function __devinit piix_init_sata_map().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sata_map is wrong.

WARNING: drivers/ata/built-in.o(.text+0x15c7d): Section mismatch in reference 
from the function piix_init_one() to the 
function .devinit.text:piix_init_pcs()
The function  piix_init_one() references
the function __devinit piix_init_pcs().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_pcs is wrong.

WARNING: drivers/ata/built-in.o(.text+0x15c86): Section mismatch in reference 
from the function piix_init_one() to the 
function .devinit.text:piix_init_sidpr()
The function  piix_init_one() references
the function __devinit piix_init_sidpr().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sidpr is wrong.

WARNING: drivers/pci/built-in.o(.text+0xf3d): Section mismatch in reference 
from the function pci_add_new_bus() to the 
function .devinit.text:pci_alloc_child_bus()
The function  pci_add_new_bus() references
the function __devinit pci_alloc_child_bus().
This is often because pci_add_new_bus lacks a __devinit 
annotation or the annotation of pci_alloc_child_bus is wrong.

WARNING: drivers/pci/built-in.o(.text+0x183d): Section mismatch in reference 
from the function pci_scan_single_device() to the 
function .devinit.text:pci_scan_device()
The function  pci_scan_single_device() references
the function __devinit pci_scan_device().
This is often because pci_scan_single_device lacks a __devinit 
annotation or the annotation of pci_scan_device is wrong.

WARNING: drivers/pci/built-in.o(.text+0x8992): Section mismatch in reference 
from the function pci_bus_size_bridges() to the 
function .devinit.text:pci_bus_size_cardbus()
The function  pci_bus_size_bridges() references
the function __devinit pci_bus_size_cardbus().
This is often because pci_bus_size_bridges lacks a __devinit 
annotation or the annotation of pci_bus_size_cardbus is wrong.

WARNING: drivers/pci/built-in.o(.text+0x8a92): Section mismatch in reference 
from the function pci_bus_assign_resources() to the 
function .devinit.text:pci_setup_bridge()
The function  pci_bus_assign_resources() references
the function __devinit pci_setup_bridge().
This is often because pci_bus_assign_resources lacks a __devinit 
annotation or the annotation of pci_setup_bridge is wrong.

WARNING: drivers/pci/built-in.o(__ksymtab+0x60): Section mismatch in reference 
from the variable __ksymtab_pci_do_scan_bus to the 
function .devinit.text:pci_do_scan_bus()
The symbol pci_do_scan_bus is exported and annotated __devinit 
Fix this by removing the __devinit annotation of pci_do_scan_bus or drop the 
export.

include/asm/io_32.h: In function ‘memcpy_fromio’:
include/asm/io_32.h:216: warning: passing argument 2 of ‘__memcpy’ 
discards qualifiers from pointer target type
WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x134): Section mismatch in 
reference from the variable pccard_sysfs_interface to the 
function .devinit.text:pccard_sysfs_add_socket()
The variable pccard_sysfs_interface references
the function __devinit pccard_sysfs_add_socket()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x138): Section mismatch in 
reference from the variable pccard_sysfs_interface to the 
function .devexit.text:pccard_sysfs_remove_socket()
The variable pccard_sysfs_interface references
the function __devexit pccard_sysfs_remove_socket()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/built-in.o(.text+0xf3d): Section mismatch in reference from 
the function pci_add_new_bus() to the 
function .devinit.text:pci_alloc_child_bus()
The function  pci_add_new_bus() references
the function __devinit pci_alloc_child_bus().
This is often because pci_add_new_bus lacks a __devinit 
annotation or the annotation of pci_alloc_child_bus is wrong.

WARNING: drivers/built-in.o(.text+0x183d): Section mismatch in reference from 
the function pci_scan_single_device() to the 
function .devinit.text:pci_scan_device()
The function  pci_scan_single_device() references
the function __devinit pci_scan_device().
This is often because pci_scan_single_device lacks a __devinit 
annotation or the annotation of pci_scan_device is wrong.

WARNING: drivers/built-in.o(.text+0x8992): Section mismatch in reference from 
the function pci_bus_size_bridges() to the 
function .devinit.text:pci_bus_size_cardbus()
The function  pci_bus_size_bridges() references
the function __devinit pci_bus_size_cardbus().
This is often because pci_bus_size_bridges lacks a __devinit 
annotation or the annotation of pci_bus_size_cardbus is wrong.

WARNING: drivers/built-in.o(.text+0x8a92): Section mismatch in reference from 
the function pci_bus_assign_resources() to the 
function .devinit.text:pci_setup_bridge()
The function  pci_bus_assign_resources() references
the function __devinit pci_setup_bridge().
This is often because pci_bus_assign_resources lacks a __devinit 
annotation or the annotation of pci_setup_bridge is wrong.

WARNING: drivers/built-in.o(.text+0x7c725): Section mismatch in reference from 
the function piix_init_one() to the 
function .devinit.text:piix_check_450nx_errata()
The function  piix_init_one() references
the function __devinit piix_check_450nx_errata().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_check_450nx_errata is wrong.

WARNING: drivers/built-in.o(.text+0x7c7c1): Section mismatch in reference from 
the function piix_init_one() to the 
function .devinit.text:piix_init_sata_map()
The function  piix_init_one() references
the function __devinit piix_init_sata_map().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sata_map is wrong.

WARNING: drivers/built-in.o(.text+0x7c82d): Section mismatch in reference from 
the function piix_init_one() to the function .devinit.text:piix_init_pcs()
The function  piix_init_one() references
the function __devinit piix_init_pcs().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_pcs is wrong.

WARNING: drivers/built-in.o(.text+0x7c836): Section mismatch in reference from 
the function piix_init_one() to the function .devinit.text:piix_init_sidpr()
The function  piix_init_one() references
the function __devinit piix_init_sidpr().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sidpr is wrong.

WARNING: drivers/built-in.o(__ksymtab+0x60): Section mismatch in reference 
from the variable __ksymtab_pci_do_scan_bus to the 
function .devinit.text:pci_do_scan_bus()
The symbol pci_do_scan_bus is exported and annotated __devinit 
Fix this by removing the __devinit annotation of pci_do_scan_bus or drop the 
export.

sound/core/init.c: In function ‘snd_card_disconnect’:
sound/core/init.c:307: warning: the address of ‘snd_shutdown_f_ops’ will 
always evaluate as ‘true’
WARNING: vmlinux.o(.text+0x6c58): Section mismatch in reference from the 
function arch_register_cpu() to the function .devinit.text:register_cpu()
The function  arch_register_cpu() references
the function __devinit register_cpu().
This is often because arch_register_cpu lacks a __devinit 
annotation or the annotation of register_cpu is wrong.

WARNING: vmlinux.o(.text+0xeca1d): Section mismatch in reference from the 
function pci_add_new_bus() to the 
function .devinit.text:pci_alloc_child_bus()
The function  pci_add_new_bus() references
the function __devinit pci_alloc_child_bus().
This is often because pci_add_new_bus lacks a __devinit 
annotation or the annotation of pci_alloc_child_bus is wrong.

WARNING: vmlinux.o(.text+0xed31d): Section mismatch in reference from the 
function pci_scan_single_device() to the 
function .devinit.text:pci_scan_device()
The function  pci_scan_single_device() references
the function __devinit pci_scan_device().
This is often because pci_scan_single_device lacks a __devinit 
annotation or the annotation of pci_scan_device is wrong.

WARNING: vmlinux.o(.text+0xed7fc): Section mismatch in reference from the 
function pci_scan_child_bus() to the 
function .devinit.text:pcibios_fixup_bus()
The function  pci_scan_child_bus() references
the function __devinit pcibios_fixup_bus().
This is often because pci_scan_child_bus lacks a __devinit 
annotation or the annotation of pcibios_fixup_bus is wrong.

WARNING: vmlinux.o(.text+0xf4472): Section mismatch in reference from the 
function pci_bus_size_bridges() to the 
function .devinit.text:pci_bus_size_cardbus()
The function  pci_bus_size_bridges() references
the function __devinit pci_bus_size_cardbus().
This is often because pci_bus_size_bridges lacks a __devinit 
annotation or the annotation of pci_bus_size_cardbus is wrong.

WARNING: vmlinux.o(.text+0xf4572): Section mismatch in reference from the 
function pci_bus_assign_resources() to the 
function .devinit.text:pci_setup_bridge()
The function  pci_bus_assign_resources() references
the function __devinit pci_setup_bridge().
This is often because pci_bus_assign_resources lacks a __devinit 
annotation or the annotation of pci_setup_bridge is wrong.

WARNING: vmlinux.o(.text+0x1111ee): Section mismatch in reference from the 
function acpi_pci_root_add() to the 
function .devinit.text:pci_acpi_scan_root()
The function  acpi_pci_root_add() references
the function __devinit pci_acpi_scan_root().
This is often because acpi_pci_root_add lacks a __devinit 
annotation or the annotation of pci_acpi_scan_root is wrong.

WARNING: vmlinux.o(.text+0x168205): Section mismatch in reference from the 
function piix_init_one() to the 
function .devinit.text:piix_check_450nx_errata()
The function  piix_init_one() references
the function __devinit piix_check_450nx_errata().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_check_450nx_errata is wrong.

WARNING: vmlinux.o(.text+0x1682a1): Section mismatch in reference from the 
function piix_init_one() to the function .devinit.text:piix_init_sata_map()
The function  piix_init_one() references
the function __devinit piix_init_sata_map().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sata_map is wrong.

WARNING: vmlinux.o(.text+0x16830d): Section mismatch in reference from the 
function piix_init_one() to the function .devinit.text:piix_init_pcs()
The function  piix_init_one() references
the function __devinit piix_init_pcs().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_pcs is wrong.

WARNING: vmlinux.o(.text+0x168316): Section mismatch in reference from the 
function piix_init_one() to the function .devinit.text:piix_init_sidpr()
The function  piix_init_one() references
the function __devinit piix_init_sidpr().
This is often because piix_init_one lacks a __devinit 
annotation or the annotation of piix_init_sidpr is wrong.

WARNING: vmlinux.o(.meminit.text+0x857): Section mismatch in reference from 
the function free_area_init_core() to the function .init.text:setup_usemap()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If free_area_init_core is only used by setup_usemap then
annotate free_area_init_core with a matching annotation.

WARNING: vmlinux.o(__ksymtab+0x24d0): Section mismatch in reference from the 
variable __ksymtab_pci_do_scan_bus to the 
function .devinit.text:pci_do_scan_bus()
The symbol pci_do_scan_bus is exported and annotated __devinit 
Fix this by removing the __devinit annotation of pci_do_scan_bus or drop the 
export.

WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x134): Section mismatch in 
reference from the variable pccard_sysfs_interface to the 
function .devinit.text:pccard_sysfs_add_socket()
The variable pccard_sysfs_interface references
the function __devinit pccard_sysfs_add_socket()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x138): Section mismatch in 
reference from the variable pccard_sysfs_interface to the 
function .devexit.text:pccard_sysfs_remove_socket()
The variable pccard_sysfs_interface references
the function __devexit pccard_sysfs_remove_socket()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/pcmcia/rsrc_nonstatic.o(.data+0x40): Section mismatch in 
reference from the variable pccard_rsrc_interface to the 
function .devinit.text:pccard_sysfs_add_rsrc()
The variable pccard_rsrc_interface references
the function __devinit pccard_sysfs_add_rsrc()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

WARNING: drivers/pcmcia/rsrc_nonstatic.o(.data+0x44): Section mismatch in 
reference from the variable pccard_rsrc_interface to the 
function .devexit.text:pccard_sysfs_remove_rsrc()
The variable pccard_rsrc_interface references
the function __devexit pccard_sysfs_remove_rsrc()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 


--Boundary-00=_b3eoHXkOKAYFBc7
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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

--Boundary-00=_b3eoHXkOKAYFBc7--
