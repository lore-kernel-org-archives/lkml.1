Return-Path: <linux-kernel-owner+w=401wt.eu-S1760045AbXIIVLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbXIIVLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759314AbXIIVLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:11:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007AbXIIVLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:11:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH -mm 0/5] Hibernation: Clean up userland interface (rev. 2)
Date: Sun, 9 Sep 2007 22:57:15 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709092257.16085.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches is intended to eliminate some design problems with the
hibernation userland interface.

It contains the following changes:
* allow the user space utilities to get the size of the image via ioctl
* introduce ioctls to be used instead of SNAPSHOT_PMOPS
* mark the SNAPSHOT_SET_SWAP_FILE ioctl as deprecated
* introduce new ioctl definitions to replace the wrongly defined ones
* move the definitions of hibernation ioctls to a separate header file located
  in include/linux/ and export them to the user space
The details are in the changelogs.

Comments welcome.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

