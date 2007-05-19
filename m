Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbXESFRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbXESFRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:17:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54236 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbXESFRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:17:15 -0400
Date: Fri, 18 May 2007 22:22:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] update dontdiff file
Message-Id: <20070518222206.a0b09f92.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update dontdiff file by adding entries from many .gitignore files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/dontdiff |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- linux-2622-rc1g8.orig/Documentation/dontdiff
+++ linux-2622-rc1g8/Documentation/dontdiff
@@ -10,10 +10,12 @@
 *.grp
 *.gz
 *.html
+*.i
 *.jpeg
 *.ko
 *.log
 *.lst
+*.moc
 *.mod.c
 *.o
 *.orig
@@ -25,6 +27,9 @@
 *.s
 *.sgml
 *.so
+*.symtypes
+*.tab.c
+*.tab.h
 *.tex
 *.ver
 *.xml
@@ -32,9 +37,13 @@
 *_vga16.c
 *cscope*
 *~
+*.9
+*.9.gz
 .*
 .cscope
 53c700_d.h
+53c7xx_d.h
+53c7xx_u.h
 53c8xx_d.h*
 BitKeeper
 COPYING
@@ -70,9 +79,11 @@ bzImage*
 classlist.h*
 comp*.log
 compile.h*
+conf
 config
 config-*
 config_data.h*
+config_data.gz*
 conmakehash
 consolemap_deftbl.c*
 crc32table.h*
@@ -81,18 +92,23 @@ defkeymap.c*
 devlist.h*
 docproc
 dummy_sym.c*
+elf2ecoff
 elfconfig.h*
 filelist
 fixdep
 fore200e_mkfirm
 fore200e_pca_fw.c*
+gconf
 gen-devlist
 gen-kdb_cmds.c*
 gen_crc32table
 gen_init_cpio
 genksyms
 gentbl
+*_gray256.c
 ikconfig.h*
+initramfs_data.cpio
+initramfs_data.cpio.gz
 initramfs_list
 kallsyms
 kconfig
@@ -100,19 +116,30 @@ kconfig.tk
 keywords.c*
 ksym.c*
 ksym.h*
+kxgettext
+lkc_defs.h
 lex.c*
+lex.*.c
+lk201-map.c
 logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
 lxdialog
 mach-types
 mach-types.h
+machtypes.h
 make_times_h
 map
 maui_boot.h
+mconf
+miboot*
 mk_elfconfig
+mkboot
+mkbugboot
 mkdep
+mkprep
 mktables
+mktree
 modpost
 modversions.h*
 offset.h
@@ -120,18 +147,28 @@ offsets.h
 oui.c*
 parse.c*
 parse.h*
+patches*
+pca200e.bin
+pca200e_ecd.bin2
+piggy.gz
+piggyback
 pnmtologo
 ppc_defs.h*
 promcon_tbl.c*
 pss_boot.h
+qconf
 raid6altivec*.c
 raid6int*.c
 raid6tables.c
+relocs
+series
 setup
 sim710_d.h*
+sImage
 sm_tbl*
 split-include
 tags
+tftpboot.img
 times.h*
 tkparse
 trix_boot.h
@@ -139,8 +176,11 @@ utsrelease.h*
 version.h*
 vmlinux
 vmlinux-*
+vmlinux.aout
 vmlinux.lds
 vsyscall.lds
 wanxlfw.inc
 uImage
-zImage
+unifdef
+zImage*
+zconf.hash.c
