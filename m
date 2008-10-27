Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYJ0VlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYJ0VlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYJ0VlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:41:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:60934 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018AbYJ0VlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:41:14 -0400
X-Authenticated: #1142740
X-Provags-ID: V01U2FsdGVkX19EC/ZrtxVE86eCwXOQLiuYEYZ6FXwvHx2wa3LA/j
	xFBfhGFK7Qmp5d
From: Hartmut Niemann <Hartmut.Niemann@gmx.de>
To: Simon Horman <horms@verge.net.au>
Subject: [PATCH] Documentation/filesystems/nfsroot.txt: CONFIG_IP_PNP must be set
Date: Mon, 27 Oct 2008 22:41:14 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Trond.Myklebust@netapp.com
References: <200810252347.01484.Hartmut.Niemann@gmx.de> <20081027052409.GC6818@verge.net.au>
In-Reply-To: <20081027052409.GC6818@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810272241.14531.Hartmut.Niemann@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file nfsroot.txt fails to mention, that Kernel level autoconfiguration 
CONFIG_IP_PNP must be selected in order to be able to even see
the option "Root file system on NFS" (CONFIG_ROOT_NFS)

I reordered the section 1 of nfsroot.txt and emphasized the dependency.
(And I fixed some chapter numbering in section 3).

Signed-off-by: Hartmut Niemann <Hartmut.Niemann@gmx.de>
---
--- linux-2.6.27.1/Documentation/filesystems/nfsroot.txt        2008-10-16 
01:02:53.000000000 +0200
+++ linux-2.6.27.1-HN/Documentation/filesystems/nfsroot.txt     2008-10-25 
23:24:48.000000000 +0200
@@ -22,15 +22,13 @@
 1.) Enabling nfsroot capabilities
     -----------------------------

-In order to use nfsroot, NFS client support needs to be selected as
-built-in during configuration. Once this has been selected, the nfsroot
-option will become available, which should also be selected.
-
-In the networking options, kernel level autoconfiguration can be selected,
-along with the types of autoconfiguration to support. Selecting all of
-DHCP, BOOTP and RARP is safe.
-
-
+In order to use nfsroot, in the networking options,  IP kernel level
+autoconfiguration must be selected, along with the types of autoconfiguration
+to support. Selecting all of DHCP, BOOTP and RARP is safe.
+
+Then NFS client support needs to be selected as built-in during
+configuration. Once this has been selected, the nfsroot option will become
+available, which must also be selected.


 2.) Kernel command line
@@ -207,7 +205,7 @@
        For more information on isolinux, including how to create bootdisks
        for prebuilt kernels, see http://syslinux.zytor.com/

-3.2) Using LILO
+3.3) Using LILO
        When using LILO all the necessary command line parameters may be
        specified using the 'append=' directive in the LILO configuration
        file.
@@ -219,11 +217,11 @@

        For information on configuring LILO, please refer to its 
documentation.

-3.3) Using GRUB
+3.4) Using GRUB
        When using GRUB, kernel parameter are simply appended after the kernel
        specification: kernel <kernel> <parameters>

-3.4) Using loadlin
+3.5) Using loadlin
        loadlin may be used to boot Linux from a DOS command prompt without
        requiring a local hard disk to mount as root. This has not been
        thoroughly tested by the authors of this document, but in general
@@ -232,7 +230,7 @@

        Please refer to the loadlin documentation for further information.

-3.5) Using a boot ROM
+3.6) Using a boot ROM
        This is probably the most elegant way of booting a diskless client.
        With a boot ROM the kernel is loaded using the TFTP protocol. The
        authors of this document are not aware of any no commercial boot
@@ -241,7 +239,7 @@
        etherboot, both of which are available on sunsite.unc.edu, and both
        of which contain everything you need to boot a diskless Linux client.

-3.6) Using pxelinux
+3.7) Using pxelinux
        Pxelinux may be used to boot linux using the PXE boot loader
        which is present on many modern network cards.

