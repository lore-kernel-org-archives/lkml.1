Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZLZAlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZLZAlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZLZAlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:41:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53625 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbZLZAlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:41:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:41:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/3] firewire: small refactoring
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves some functionality related to config ROM parsing into a core
function for use by drivers (repost of a patch from Clemens Ladisch to
linux1394-devel), plus small related bits.

firewire: add fw_csr_string() helper function
firewire: core: fw_csr_string addendum
firewire: qualify config ROM cache pointers as const pointers

 drivers/firewire/core-device.c          |  127 ++++++++++++++++--------
 drivers/firewire/sbp2.c                 |    5 
 drivers/media/dvb/firewire/firedtv-fw.c |   39 -------
 include/linux/firewire.h                |   11 +-
 4 files changed, 103 insertions(+), 79 deletions(-)
-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

