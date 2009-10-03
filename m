Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbZJCEHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbZJCEHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 00:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZJCEHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 00:07:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:52835 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZJCEHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 00:07:34 -0400
Message-ID: <4AC6CE04.20901@interlog.com>
Date: Sat, 03 Oct 2009 00:07:32 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>,
       kumba@gentoo.org
Subject: [ANNOUNCE] sdparm 1.04 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD/BD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since June 2008.


ChangeLog for sdparm-1.04 [20090920] [svn: r129]
   - add SAT ATA Power condition mode page (sat2r06)
   - add SBC Thin provisioning mode page (sbc3r20)
   - add SBC Thin provisioning VPD page (sbc3r20)
   - sync with spc4r21
   - add Power condition, update extended inquiry VPD pages
   - smc3: add Device capabilities + Extended device
     capabilities + Transport geometry parameters mode pages
   - prepare for Thin provisioning VPD and mode pages
   - expand block limits VPD page
   - update Power condition mode page
   - rename SAS-2 phy mode page to Enhanced phy control (SAS)
   - add ADC mode (sub)page place holders
   - print mode page descriptors in full in more contexts
   - add linux bsg support
   - scripts/sas_disk_blink: moved here from sg3_utils package
   - rework the '-w' option (win32) per sg_scan in sg3_utils
   - change SDPARM_* constants to SG_LIB_*
   - remove sdparm.html, refer to its url in sdparm.8
   - sdparm.spec: correction to configure call

ChangeLog for sdparm-1.03 [20080623] [svn: r96]
....


For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html
Note that the web site has changed since the previous release.

A release announcement will be sent to freshmeat.net .

Doug Gilbert
