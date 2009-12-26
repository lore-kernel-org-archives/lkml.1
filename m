Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZLZAfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZLZAfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZLZAfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:35:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53603 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbZLZAfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:35:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:32:35 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/5] firewire: fixes, status update
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
Message-ID: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following as replies:  Some patches which are IMO suitable to be merged
during the .33-rc time frame.

The first patch enabled me to run the three FCP clients FFADO, Kino
(both libraw1394 based userspace), and firedtv (kernelspace) at the same
time.  Thanks to Clemens Ladisch.

firewire: fix use of multiple AV/C devices, allow multiple FCP listeners
firewire: cdev: fix another memory leak in an error path
firewire: ohci: always use packet-per-buffer mode for isochronous reception
firewire, ieee1394: update MAINTAINERS entries
firewire, ieee1394: update Kconfig help

 MAINTAINERS                             |   15 ---
 drivers/Kconfig                         |    2 
 drivers/firewire/Kconfig                |   44 ++------
 drivers/firewire/core-cdev.c            |   27 +++--
 drivers/firewire/core-transaction.c     |  118 +++++++++++++++++++-----
 drivers/firewire/ohci.c                 |    4 
 drivers/ieee1394/Kconfig                |   59 ++++++++----
 drivers/media/dvb/firewire/firedtv-fw.c |   12 --
 include/linux/firewire-cdev.h           |    3 
 include/linux/firewire.h                |    4 
 10 files changed, 182 insertions(+), 106 deletions(-)
-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/


