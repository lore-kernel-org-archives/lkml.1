Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYAYHRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYAYHRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYAYHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:14:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbYAYHOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH 013/196] Documentation: Replace obsolete "driverfs" with "sysfs".
Date: Thu, 24 Jan 2008 23:09:11 -0800
Message-Id: <1201245134-4876-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert P. J. Day <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
---
 Documentation/pnp.txt      |    4 ++--
 Documentation/s390/cds.txt |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/pnp.txt b/Documentation/pnp.txt
index 481faf5..a327db6 100644
--- a/Documentation/pnp.txt
+++ b/Documentation/pnp.txt
@@ -17,9 +17,9 @@ The User Interface
 ------------------
 	The Linux Plug and Play user interface provides a means to activate PnP devices
 for legacy and user level drivers that do not support Linux Plug and Play.  The 
-user interface is integrated into driverfs.
+user interface is integrated into sysfs.
 
-In addition to the standard driverfs file the following are created in each 
+In addition to the standard sysfs file the following are created in each
 device's directory:
 id - displays a list of support EISA IDs
 options - displays possible resource configurations
diff --git a/Documentation/s390/cds.txt b/Documentation/s390/cds.txt
index 3081927..c4b7b2b 100644
--- a/Documentation/s390/cds.txt
+++ b/Documentation/s390/cds.txt
@@ -133,7 +133,7 @@ During its startup the Linux/390 system checks for peripheral devices. Each
 of those devices is uniquely defined by a so called subchannel by the ESA/390
 channel subsystem. While the subchannel numbers are system generated, each
 subchannel also takes a user defined attribute, the so called device number.
-Both subchannel number and device number cannot exceed 65535. During driverfs
+Both subchannel number and device number cannot exceed 65535. During sysfs
 initialisation, the information about control unit type and device types that 
 imply specific I/O commands (channel command words - CCWs) in order to operate
 the device are gathered. Device drivers can retrieve this set of hardware
-- 
1.5.3.8

