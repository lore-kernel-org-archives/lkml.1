Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZJDMUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZJDMUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZJDMUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:20:13 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:48701 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZJDMUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:20:11 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Oct 2009 08:20:11 EDT
Subject: 2.6.32-rc1-git5 compilation warnings
From: Rufus & Azrael <rufus-azrael@numericable.fr>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-5wJGvLYEfNkHPHabnnla"
Date: Sun, 04 Oct 2009 14:08:18 +0200
Message-Id: <1254658098.547.1.camel@athlon64_X2_Gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5wJGvLYEfNkHPHabnnla
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

Here are my compilation warnings for fresh 2.6.32-rc1-git5 kernel if it
could help.

Thanks for all your job.



--=-5wJGvLYEfNkHPHabnnla
Content-Disposition: attachment; filename="compilation_warnings_for_2_6_32_rc1_git5"
Content-Type: text/plain; name="compilation_warnings_for_2_6_32_rc1_git5"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

_____________________________________________________________________________________________________________
warn_unused_result warnings



scripts/kconfig/conf.c: In function 'conf_askvalue':
scripts/kconfig/conf.c:105: warning: ignoring return value of 'fgets', declared with attribute warn_unused_result

scripts/kconfig/conf.c: In function 'conf_choice':
scripts/kconfig/conf.c:307: warning: ignoring return value of 'fgets', declared with attribute warn_unused_result

In file included from scripts/kconfig/zconf.tab.c:2486:
scripts/kconfig/confdata.c: In function 'conf_write':
scripts/kconfig/confdata.c:508: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

scripts/kconfig/confdata.c: In function 'conf_write_autoconf':
scripts/kconfig/confdata.c:745: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result
scripts/kconfig/confdata.c:746: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

In file included from scripts/kconfig/zconf.tab.c:2487:
scripts/kconfig/expr.c: In function 'expr_print_file_helper':
scripts/kconfig/expr.c:1090: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

scripts/mod/modpost.c: In function 'get_markers':
scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf', declared with attribute warn_unused_result

scripts/mod/modpost.c: In function 'add_marker':
scripts/mod/modpost.c:1982: warning: ignoring return value of 'asprintf', declared with attribute warn_unused_result

scripts/kallsyms.c: In function 'read_symbol':
scripts/kallsyms.c:112: warning: ignoring return value of 'fgets', declared with attribute warn_unused_result

usr/gen_init_cpio.c: In function 'cpio_mkfile':
usr/gen_init_cpio.c:357: warning: ignoring return value of 'fwrite', declared with attribute warn_unused_result

arch/x86/boot/compressed/mkpiggy.c: In function 'main':
arch/x86/boot/compressed/mkpiggy.c:65: warning: ignoring return value of 'fread', declared with attribute warn_unused_result


_____________________________________________________________________________________________________________
section mismatches warnings



WARNING: drivers/acpi/processor.o(.text+0xc35): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit 
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: drivers/acpi/built-in.o(.text+0x35c71): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit 
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: drivers/staging/comedi/drivers/cb_pcidio.o(.text+0x15b): Section mismatch in reference from the function pcidio_attach() to the variable .devinit.rodata:pcidio_pci_table
The function pcidio_attach() references
the variable __devinitconst pcidio_pci_table.
This is often because pcidio_attach lacks a __devinitconst 
annotation or the annotation of pcidio_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x28a8): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x28af): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x28b9): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x28c3): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst 
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/built-in.o(.text+0x9c5a1): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit 
annotation or the annotation of acpi_processor_power_init is wrong.

WARNING: vmlinux.o(.text+0x2b2d39): Section mismatch in reference from the function acpi_processor_add() to the function .cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit 
annotation or the annotation of acpi_processor_power_init is wrong.

_____________________________________________________________________________________________________________
types of data warnings



drivers/connector/cn_proc.c: In function 'cn_proc_init':
drivers/connector/cn_proc.c:263: warning: passing argument 3 of 'cn_add_callback' from incompatible pointer type

include/linux/connector.h:167: note: expected 'void (*)(struct cn_msg *, struct netlink_skb_parms *)' but argument is of type 'void (*)(struct cn_msg *)'

drivers/staging/comedi/comedi_fops.c: In function 'resize_async_buffer':
drivers/staging/comedi/comedi_fops.c:2339: warning: format '%d' expects type 'int', but argument 3 has type 'long int'

drivers/staging/comedi/drivers/serial2002.c: In function 'serial_2002_open':
drivers/staging/comedi/drivers/serial2002.c:680: warning: the frame size of 2160 bytes is larger than 2048 bytes

_____________________________________________________________________________________________________________
deprecated, unitialized and not_used variables warnings



drivers/platform/x86/thinkpad_acpi.c:2224: warning: 'tpacpi_hotkey_driver_mask_set' defined but not used

drivers/uwb/i1480/i1480-est.c:94: warning: 'i1480_est_id_table' defined but not used
drivers/uwb/wlp/messages.c: In function 'wlp_parse_f0':
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[2]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[3]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[4]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[5]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[6]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[7]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[8]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[9]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[10]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[11]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[12]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[13]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[14]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[15]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[2]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[3]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[4]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[5]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[6]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[7]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[8]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[9]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[10]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[11]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[12]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[13]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[14]' may be used uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[15]' may be used uninitialized in this function

drivers/uwb/whc-rc.c:450: warning: 'whcrc_id_table' defined but not used



net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at net/ethernet/eth.c:397)
net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at net/ethernet/eth.c:397)

_____________________________________________________________________________________________________________
other warnings



drivers/video/console/fbcon.c: In function 'fbcon_takeover':
drivers/video/console/fbcon.c:532: warning: unused variable 'info'
drivers/video/console/fbcon.c: In function 'fbcon_modechanged':
drivers/video/console/fbcon.c:2987: warning: ISO C90 forbids mixed declarations and code

/var/tmp/kernel/linux-2.6.32-rc1/usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
/var/tmp/kernel/linux-2.6.32-rc1/usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

--=-5wJGvLYEfNkHPHabnnla--

