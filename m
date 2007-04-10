Return-Path: <linux-kernel-owner+w=401wt.eu-S1030325AbXDJCmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbXDJCmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030323AbXDJCmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:42:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030320AbXDJCmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:42:13 -0400
Message-ID: <461AF881.6080301@torque.net>
Date: Mon, 09 Apr 2007 22:37:53 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, tomfa@debian.org, kumba@gentoo.org
Subject: [ANNOUNCE] sdparm 1.01
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Virtually all CD/DVD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the linux
kernel 2.4 and 2.6 series with ports to FreeBSD and Windows.

ChangeLog for sdparm-1.01 [20070405]
  - add element address assignment mode page (smc)
  - improve error handling in lk 2.4 series mapping to
    sg devices
  - add configure.ac rule for mingw (Windows)
    - include <inttypes.h> to use PRIx64 instead of %llx
  - add LUICLR bit to extended inquiry VPD page
  - correct some headers for C++ inclusion
    - fix some C code to compile under C++
  - fix bug when unusual transport or vendor given
  - add a Fujitsu vendor mode page
  - add "initial priority" to control extension mpage
  - add "disconnect-reconnect" mpage to generic list;
    there are still transport specific versions
  - extend block limits VPD page (sbc3r09)
  - sync with sg3_utils-1.24 pass-through code

For more information and downloads see:
http://www.torque.net/sg/sdparm.html

A release announcement has been sent to freshmeat.net .

Doug Gilbert
