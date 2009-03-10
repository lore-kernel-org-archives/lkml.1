Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZCJT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZCJT7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZCJT7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:59:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48104 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZCJT7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:59:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 10 Mar 2009 20:58:39 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/5] firewire: cdev interface updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.700492025c5bb3e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll follow up with these proposed updates to the character device file
interface of firewire-core:

 firewire: cdev: amendment to "add ioctl to query maximum transmission speed"
 firewire: cdev: secure add_descriptor ioctl
 firewire: cdev: fix race of ioctl_send_request with bus reset
 firewire: cdev: simplify FW_CDEV_IOC_SEND_REQUEST return value
 firewire: cdev: add closure to async stream ioctl

 drivers/firewire/fw-cdev.c        |   79 ++++++++++++++----------------
 drivers/firewire/fw-transaction.c |   42 ++++++---------
 drivers/firewire/fw-transaction.h |    9 +--
 include/linux/firewire-cdev.h     |   73 ++++++++++++---------------
 4 files changed, 93 insertions(+), 110 deletions(-)

Please comment.
-- 
Stefan Richter
-=====-==--= --== -=-=-
http://arcgraph.de/sr/


