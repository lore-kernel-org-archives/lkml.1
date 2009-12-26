Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbZLZAgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbZLZAgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbZLZAgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:36:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53612 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbZLZAgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:36:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:36:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/5] firewire, ieee1394: update MAINTAINERS entries
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>, Dan Dennedy <dan@dennedy.org>,
       Kristian Hoegsberg <krh@bitplanet.net>
In-Reply-To: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
Message-ID: <tkrat.92e0244677f2fc0a@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben and Kristian have not been involved in maintenance of the IEEE 1394
drivers for quite some time; submitters are not required to Cc them on
patches.

The linux1394.org domain has been dead for a while and is no longer
under control of a Linux developer.  The current web site of the
Linux 1394 project is http://ieee1394.wiki.kernel.org/.

The classic drivers/ieee1394/ stack is now obsolete from the development
point of view, though still a useful alternative in productive use.  But
nobody should attempt to submit style cleanup patches for it or to
develop new drivers on top of this stack, hence mark its MAINTAINERS
entry as Obsolete.

drivers/ieee1394/raw1394*, like the rest of the old stack, does not
receive bigger code changes anymore, hence shrink the MAINTAINERS
database a bit by dropping raw1394's special entry.  If something
important and urgent is going to come up for raw1394, I will make sure
that Dan will be notified of it besides via linux1394-devel.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ben Collins <ben.collins@ubuntu.com>
Cc: Dan Dennedy <dan@dennedy.org>
Cc: Kristian Hoegsberg <krh@bitplanet.net>
---
 MAINTAINERS |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6.33-rc2/MAINTAINERS
===================================================================
--- linux-2.6.33-rc2.orig/MAINTAINERS
+++ linux-2.6.33-rc2/MAINTAINERS
@@ -2169,10 +2169,9 @@ F:	drivers/hwmon/f75375s.c
 F:	include/linux/f75375s.h
 
 FIREWIRE SUBSYSTEM
-M:	Kristian Hoegsberg <krh@redhat.com>
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
-W:	http://www.linux1394.org/
+W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
 S:	Maintained
 F:	drivers/firewire/
@@ -2705,22 +2704,14 @@ S:	Supported
 F:	drivers/idle/i7300_idle.c
 
 IEEE 1394 SUBSYSTEM
-M:	Ben Collins <ben.collins@ubuntu.com>
 M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
 L:	linux1394-devel@lists.sourceforge.net
-W:	http://www.linux1394.org/
+W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
-S:	Maintained
+S:	Obsolete
 F:	Documentation/debugging-via-ohci1394.txt
 F:	drivers/ieee1394/
 
-IEEE 1394 RAW I/O DRIVER
-M:	Dan Dennedy <dan@dennedy.org>
-M:	Stefan Richter <stefanr@s5r6.in-berlin.de>
-L:	linux1394-devel@lists.sourceforge.net
-S:	Maintained
-F:	drivers/ieee1394/raw1394*
-
 IEEE 802.15.4 SUBSYSTEM
 M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
 M:	Sergey Lapin <slapin@ossfans.org>

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

