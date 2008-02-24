Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYBXVDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYBXVDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYBXVDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:03:40 -0500
Received: from n66.bullet.mail.sp1.yahoo.com ([98.136.44.50]:44822 "HELO
	n66.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753277AbYBXVDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:03:39 -0500
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 16:03:39 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 308676.44168.bm@omp204.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ENOFR0BulVGdZqGZdFxoUP2Cr38zp2S3hs1eD96+xG+iAWFCBjztnNglpAoJNh9cciT67REQFChzMXbP7E+8RqZqz6koZB8cCGAVY4Y8VVY4k1+4pBZ3fVgeeQPoMb8vlqxwUo3TP/3HCybVL31aSXy7KWLTPaM7Nf6Q5BK+ANE=;
X-YMail-OSG: QCLZbYoVM1nlE4cGMONydHCyVpJEsRWR_lZgR55d.qcl2xOgPlpP9X8veOBF8l7MPZ3Vch7ErF2DjAQII8hRcBaM4Q--
Date: Sun, 24 Feb 2008 12:57:00 -0800 (PST)
From: zkopex <zkopex@yahoo.com>
Subject: [Regression in 2.6.25-rcX] CD/DVD writer no longer works
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <211548.78349.qm@web45213.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using Debian Sid on a Toshiba A100 laptop. My CD/DVD
writer functions very well on 2.6.23.16 and 2.6.24.2.

I tried 2.6.25-rc2-git7, and I was very sad to notice that
when I tried to write a CD, wodim started to output the
following: "Warning: controller returns zero sized CD
capabilities page."

Since I was able to use this CD/DVD writer successfully with
previous versions of Linux, I believe that this is a regression
in 2.6.25-rcX series.

I am willing to try patches and to do pretty much anything
to debug/fix this problem.

Thanks in advance.

Note: I am attaching the output of wodim to this e-mail.

- zkopex

--- output of wodim ---
root@debian:~# wodim -v dev=/dev/sr0 blank=fast hardy-desktop-i386.iso
wodim: No write mode specified.
wodim: Asuming -tao mode.
wodim: Future versions of wodim may have different drive dependent defaults.
TOC Type: 1 = CD-ROM
scsidev: '/dev/sr0'
devname: '/dev/sr0'
scsibus: -2 target: -2 lun: -2
Linux sg driver version: 3.5.27
Wodim version: 1.1.6
SCSI buffer size: 64512
wodim: Warning: controller returns zero sized CD capabilities page.
wodim: Warning: controller returns wrong page 0 for CD capabilities page (2A).
Device type    : Removable CD-ROM
Version        : 5
Response Format: 2
Capabilities   :
Vendor_info    : 'MATSHITA'
Identification : 'DVD-RAM UJ-841S '
Revision       : '1.60'
Device seems to be: Generic CD-ROM.
wodim: Warning: controller returns zero sized CD capabilities page.
wodim: Warning: controller returns wrong page 0 for CD capabilities page (2A).
wodim: Warning: controller returns zero sized CD capabilities page.
wodim: Warning: controller returns wrong page 0 for CD capabilities page (2A).
wodim: Warning: controller returns zero sized CD capabilities page.
wodim: Warning: controller returns wrong page 0 for CD capabilities page (2A).
wodim: Sorry, no CD/DVD-Recorder or unsupported CD/DVD-Recorder found on this
target.
wodim: Warning: controller returns zero sized CD capabilities page.
wodim: Warning: controller returns wrong page 0 for CD capabilities page (2A).
Using generic SCSI-2       CD-ROM driver (scsi2_cd).
Driver flags   :
Supported modes:
Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
communication breaks or freezes immediately after that.
FIFO size      : 12582912 = 12288 KB
wodim: Drive does not support TAO recording.
wodim: Illegal write mode for this drive.
--- output of wodim ---



      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping

