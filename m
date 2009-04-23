Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZDWTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZDWTYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZDWTYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:24:37 -0400
Received: from n64.bullet.mail.sp1.yahoo.com ([98.136.44.189]:42901 "HELO
	n64.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754436AbZDWTYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:24:36 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 15:24:36 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 915955.22907.bm@omp115.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=DEkMkGZ+GTs4oUTfEDYHB2nT0pkWMYW+ityR3EZYeHLUb4oynAgXcgrd8D3XDGRBwYkR68EMLUj5I7UmhV0QotSYWKaBVg0qa88/Zca2Q2/LUI+aN+hkijQcUK5xhIWz3RrGEXt8KCVrBT6bGVEJmE1nguaHOVTI/p6JHYeTdLs=;
Message-ID: <72010.86725.qm@web112215.mail.gq1.yahoo.com>
X-YMail-OSG: kLAOAfEVM1nFMHbTx_jJ7EY.1yVYAomeR0nvALT4p24l7NRD0Gq8lo5NOvlUqZgDL33bn2xZbPMA6PDW5Ij_98QPngaqTfskmuI_T.kwaU5DYj5RDpinWluIMuTCCE8LfMxNxEKOVUArVke5LokMuxaN3HYwkUzvLVwe_yu5TBRL5nE5LFLwFQuR4ibXYy1bXcAvCIHqLBBpvSntRUoPNkx3BX9SGZjTaA802RGnTzZAb5RDl13bRmN_n.L4jPpq6e8AWzGX4tQwit3EIe1.BQjaOg--
X-Mailer: YahooMailClassic/5.2.19 YahooMailWebService/0.7.289.1
Date: Thu, 23 Apr 2009 12:19:02 -0700 (PDT)
From: We La <w.landgraf@yahoo.com>
Subject: 2.6.30-rc3 : Regression: i915 , video
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Problems on MSI U100 laptop:

root@werner:~# modprobe i915
WARNING: Error inserting video (/lib/modules/2.6.30-rc3/kernel/drivers/acpi/video.ko): No such device
FATAL: Error inserting i915 (/lib/modules/2.6.30-rc3/kernel/drivers/gpu/drm/i915/i915.ko): Unknown symbol in module, or unknown parameter (see dmesg)
root@werner:~#

Apr 23 16:16:57 localhost kernel: i915: Unknown symbol acpi_video_register


On older kernels this drivers worked

Werner Landgraf
Linux  SYS



      

