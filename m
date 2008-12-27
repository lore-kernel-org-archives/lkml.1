Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYL0Dko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYL0Dko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 22:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYL0Dkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 22:40:35 -0500
Received: from smtp.infotech.no ([82.134.31.41]:33374 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYL0Dke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 22:40:34 -0500
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2008 22:40:34 EST
Message-ID: <4955A120.3060703@interlog.com>
Date: Fri, 26 Dec 2008 22:29:36 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Matt Taggart <taggart@debian.org>
Subject: [ANNOUNCE] lsscsi-0.22 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.22 is available at
http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.

ChangeLog:
Version 0.22 2008/12/26 [svn: r71]
   - add protection information (see CREDITS file)
   - add USB transport type with USB device name
   - add ATA and SATA transport types (crude: by driver name)
Version 0.21 2008/7/10 [svn: r64]
   ....

Example of some new features:
$ lsscsi
[0:0:0:0]    disk    ATA      FUJITSU MHY2160B 0000  /dev/sda
[3:0:0:0]    cd/dvd  MATSHITA DVD/CDRW UJDA775 CB03  /dev/scd0
[5:0:0:0]    disk    USB 2.0  SD/MMC Reader          /dev/sdb
[6:0:0:0]    disk    JetFlash TS2GJFVxx        8.01  /dev/sdc

$ lsscsi -t
[0:0:0:0]    disk    sata:                           /dev/sda
[3:0:0:0]    cd/dvd  ata:                            /dev/scd0
[5:0:0:0]    disk    usb: 7-1:1.0                    /dev/sdb
[6:0:0:0]    disk    usb: 7-2.4:1.0                  /dev/sdc


Doug Gilbert
