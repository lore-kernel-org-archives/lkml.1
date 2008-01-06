Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbYAFPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbYAFPVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYAFPVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:21:07 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:50642 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118AbYAFPVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:21:05 -0500
Date: Sun, 6 Jan 2008 16:21:00 +0100
From: FD Cami <francois.cami@free.fr>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Boldi <a1426z@gawab.com>
Subject: [PATCH] Re: Forcing modes in libata (was: SATA buffered read VERY
 slow)
Message-ID: <20080106162100.05096d60@dimension.stilgar.hd.free.fr>
In-Reply-To: <20080106133609.51203eed@lxorguk.ukuu.org.uk>
References: <200801051641.03927.a1426z@gawab.com>
	<20080105163016.608b1e7f@lxorguk.ukuu.org.uk>
	<200801060803.31939.a1426z@gawab.com>
	<20080106133609.51203eed@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/4bRucLNHguQ/leqAk6FsH4R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/4bRucLNHguQ/leqAk6FsH4R
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sun, 6 Jan 2008 13:36:09 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 6 Jan 2008 08:03:31 +0300
> > > For now you can boot with libata.dma=3D1 to select DMA on disks but
> > > not CD
> >=20
> > Great, but why isn't this in the documentation?
>=20
> Send patches

patch attached.

Description : Add libata.dma=3D to Documentation/kernel-parameters.txt

Found documentation in :
http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg09849.html
http://www.redhat.com/archives/fedora-extras-commits/2007-October/msg04568.=
html

Signed-off-by: Fran=C3=A7ois Cami <francois.cami@free.fr>

--MP_/4bRucLNHguQ/leqAk6FsH4R
Content-Type: text/plain; name=libata-doc-patch.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=libata-doc-patch.txt

diff -rU2 linux-2.6.24-rc6/Documentation/kernel-parameters.txt linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt
--- linux-2.6.24-rc6/Documentation/kernel-parameters.txt	2008-01-06 15:58:54.000000000 +0100
+++ linux-2.6.24-rc6-mine/Documentation/kernel-parameters.txt	2008-01-06 16:11:20.000000000 +0100
@@ -883,4 +883,11 @@
 			C2 power state.
 
+	libata.dma=	[LIBATA] DMA control
+			libata.dma=0	  Disable all PATA DMA like old IDE
+			libata.dma=1	  Disk DMA only
+			libata.dma=2	  ATAPI DMA only
+			libata.dma=3	  CF DMA only 
+			libata.dma=0,1,3  Combinations also work.
+
 	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
 			when set.

--MP_/4bRucLNHguQ/leqAk6FsH4R--
