Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZGEOWS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sun, 5 Jul 2009 10:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbZGEOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:22:09 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:57486 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZGEOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:22:08 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 10:22:07 EDT
Subject: kernel 2.6.31-rc2 compilation warnings
From: Rufus & Azrael <rufus-azrael@numericable.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 05 Jul 2009 16:16:04 +0200
Message-Id: <1246803364.15322.2.camel@athlon64_X2_Gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are my compilation warnings for fresh 2.6.31-rc2 kernel, hope it 
could help you to fix them.

Thanks for your attention and good job.


------------------------------------------------------------------------
warnings with CONFIG_ENABLE_MUST_CHECK=y


scripts/kconfig/conf.c: In function 'conf_askvalue':
scripts/kconfig/conf.c:105: warning: ignoring return value of 'fgets', 
declared with attribute warn_unused_result

scripts/kconfig/conf.c: In function 'conf_choice':
scripts/kconfig/conf.c:307: warning: ignoring return value of 'fgets', 
declared with attribute warn_unused_result

In file included from scripts/kconfig/zconf.tab.c:2486:

scripts/kconfig/confdata.c: In function 'conf_write':
scripts/kconfig/confdata.c:508: warning: ignoring return value of 
'fwrite', declared with attribute warn_unused_result

scripts/kconfig/confdata.c: In function 'conf_write_autoconf':
scripts/kconfig/confdata.c:745: warning: ignoring return value of 
'fwrite', declared with attribute warn_unused_result
scripts/kconfig/confdata.c:746: warning: ignoring return value of 
'fwrite', declared with attribute warn_unused_result


In file included from scripts/kconfig/zconf.tab.c:2487:

scripts/kconfig/expr.c: In function 'expr_print_file_helper':
scripts/kconfig/expr.c:1090: warning: ignoring return value of
'fwrite', 
declared with attribute warn_unused_result

scripts/mod/modpost.c: In function 'get_markers':
scripts/mod/modpost.c:1562: warning: ignoring return value of
'asprintf', 
declared with attribute warn_unused_result

scripts/mod/modpost.c: In function 'add_marker':
scripts/mod/modpost.c:1982: warning: ignoring return value of
'asprintf', 
declared with attribute warn_unused_result

scripts/kallsyms.c: In function 'read_symbol':
scripts/kallsyms.c:112: warning: ignoring return value of 'fgets', 
declared with attribute warn_unused_result

usr/gen_init_cpio.c: In function 'cpio_mkfile':
usr/gen_init_cpio.c:357: warning: ignoring return value of 'fwrite', 
declared with attribute warn_unused_result

drivers/platform/x86/thinkpad_acpi.c: In function 'tpacpi_new_rfkill':
drivers/platform/x86/thinkpad_acpi.c:1272: warning: ignoring return
value 
of 'rfkill_set_hw_state', declared with attribute warn_unused_result


arch/x86/boot/compressed/mkpiggy.c: In function 'main':
arch/x86/boot/compressed/mkpiggy.c:65: warning: ignoring return value
of 
'fread', declared with attribute warn_unused_result

-------------------------------------------------------------------------
warnings for variables length


drivers/staging/comedi/comedi_fops.c: In function 'resize_async_buffer':
drivers/staging/comedi/comedi_fops.c:2311: warning: format '%d' expects 
type 'int', but argument 3 has type 'long int'

drivers/staging/epl/EplApiGeneric.c: In function 'EplApiInitialize':
drivers/staging/epl/EplApiGeneric.c:238: warning: comparison of
distinct 
pointer types lacks a cast

drivers/staging/epl/EplApiLinuxKernel.c: In function 'EplLinIoctl':
drivers/staging/epl/EplApiLinuxKernel.c:938: warning: comparison of 
distinct pointer types lacks a cast

drivers/staging/epl/EplSdoUdpu.c: In function 'EplSdoUdpuDelInstance':
drivers/staging/epl/EplSdoUdpu.c:249: warning: passing argument 2 of 
'send_sig' makes pointer from integer without a cast

drivers/staging/epl/EplSdoUdpu.c: In function 'EplSdoUdpuConfig':
drivers/staging/epl/EplSdoUdpu.c:299: warning: passing argument 2 of 
'send_sig' makes pointer from integer without a cast

drivers/staging/epl/ShbIpc-LinuxKernel.c: In function 
'ShbIpcStopSignalingNewData':
drivers/staging/epl/ShbIpc-LinuxKernel.c:571: warning: passing argument
2 
of 'send_sig' makes pointer from integer without a cast

drivers/staging/epl/Edrv8139.c: In function 'EdrvInitOne':
drivers/staging/epl/Edrv8139.c:1021: warning: passing argument 2 of 
'request_irq' from incompatible pointer type

-----------------------------------------------------------------------
warnings for used_unitialized or defined_but_not_used variables


drivers/uwb/i1480/i1480-est.c:94: warning: 'i1480_est_id_table' defined 
but not used
drivers/uwb/wlp/messages.c: In function 'wlp_parse_f0':

drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[15]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[14]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[13]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[12]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[11]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[10]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[9]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[8]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[7]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[6]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[5]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[4]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[3]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'enonce.data[2]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[15]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[14]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[13]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[12]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[11]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[10]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[9]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[8]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[7]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[6]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[5]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[4]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[3]' may be used 
uninitialized in this function
drivers/uwb/wlp/messages.c:906: warning: 'rnonce.data[2]' may be used 
uninitialized in this function

drivers/uwb/whc-rc.c:451: warning: 'whcrc_id_table' defined but not used

------------------------------------------------------------------------
warning for section mismatch


WARNING: drivers/staging/comedi/drivers/cb_pcidio.o(.text+0x1c6):
Section 
mismatch in reference from the function pcidio_attach() to the 
variable .devinit.rodata:pcidio_pci_table
The function pcidio_attach() references
the variable __devinitconst pcidio_pci_table.
This is often because pcidio_attach lacks a __devinitconst 
annotation or the annotation of pcidio_pci_table is wrong.

