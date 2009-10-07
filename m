Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbZJGWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbZJGWj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZJGWj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:39:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44033 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbZJGWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:39:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:38:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/8] firewire: misc updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coming up: Small fixes, reduction in stack usage, code style tweaks.

[PATCH 1/8] firewire: sbp2: provide fallback if mgt_ORB_timeout is missing
[PATCH 2/8] firewire: cdev: fix memory leak in an error path
[PATCH 3/8] firewire: cdev: reduce stack usage by ioctl_dispatch
[PATCH 4/8] firewire: normalize style of queue_work wrappers
[PATCH 5/8] firewire: cdev: normalize variable names
[PATCH 6/8] firewire: optimize config ROM creation
[PATCH 7/8] firewire: core: clarify generate_config_rom usage
[PATCH 8/8] firewire: core: optimize Topology Map creation

 drivers/firewire/core-card.c        |   75 +++++++++----------
 drivers/firewire/core-cdev.c        |  136 +++++++++++++++++++++---------------
 drivers/firewire/core-topology.c    |   17 ++--
 drivers/firewire/core-transaction.c |    9 --
 drivers/firewire/core.h             |    9 +-
 drivers/firewire/ohci.c             |   30 +++++--
 drivers/firewire/sbp2.c             |   48 ++++++------
 include/linux/firewire.h            |   16 ----
 8 files changed, 177 insertions(+), 163 deletions(-)
-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

