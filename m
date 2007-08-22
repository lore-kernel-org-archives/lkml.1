Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbXHWM2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbXHWM2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbXHWM2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:28:23 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57242 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760872AbXHWM2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:28:22 -0400
Date: Wed, 22 Aug 2007 20:44:40 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Patrick Gefre <pfg@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Add MAINTAINERS entry for IOC3 serial driver
Message-ID: <20070822194440.GA3903@linux-mips.org>
References: <Pine.SGI.3.96.1070815090732.63602A-100000@fsgi900.americas.sgi.com> <1187199095.7443.25.camel@localhost> <46CB73FD.10009@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CB73FD.10009@sgi.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The IOC3 is a multifunction device but not in sense of the PCI
specification.  Currently its ethernet and serial functionality are
supported by two separate drivers authored and maintained by different
people, so MAINTAINERS should reflect that.

diff --git a/MAINTAINERS b/MAINTAINERS
index 371fe67..d98dabd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2057,12 +2057,18 @@ L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
-IOC3 DRIVER
+IOC3 ETHERNET DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
 
+IOC3 SERIAL DRIVER
+P:	Pat Gefre
+M:	pfg@sgi.com
+L:	linux-kernel@linux-mips.org
+S:	Maintained
+
 IP MASQUERADING:
 P:	Juanjo Ciarlante
 M:	jjciarla@raiz.uncu.edu.ar
