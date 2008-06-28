Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYF1RkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYF1RkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYF1Rj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:39:57 -0400
Received: from elrond2.infotech.no ([82.134.31.41]:35639 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYF1Rj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:39:56 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 13:39:56 EDT
Message-ID: <4866753B.5070107@torque.net>
Date: Sat, 28 Jun 2008 13:30:35 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tomas Fasth <tomfa@debian.org>, Kumba <kumba@gentoo.org>
Subject: [ANNOUNCE] sdparm 1.03
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version adds commands to set the (maximum or optimal)
media speed in CD/DVD/BD drives and show the drive/media
profile. It also tracks changes in drafts from www.t10.org
since the previous release.


ChangeLog for sdparm-1.03 [20080623] [svn: r96]
   - allow more than one DEVICE argument on command line
   - add speed[=val] and profile commands for MMC
   - update Extended Inquiry VPD page to spc4r15
   - 'di' VPD page: decode "NAA Locally assigned"
   - SAS protocol-specific port mpage (subpage=0)
     - add CAWT (sas2r13) and RTOL (sas2r14)
   - change 'long long' to int64_t to stress only require
     64 bit integers (similar change to uint64_t)
   - cleanup to use sg_cmds_mmc and PDT_* defines
   - define SDPARM_MINGW when configure detects it
   - sync with debian unstable files: debian/rules+changelog

ChangeLog for sdparm-1.02 [20071008] [svn: r59]
....


For more information and downloads see:
http://www.torque.net/sg/sdparm.html

A release announcement has been sent to freshmeat.net .

Doug Gilbert
