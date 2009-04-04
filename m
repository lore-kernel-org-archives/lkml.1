Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbZDDVll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbZDDVll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZDDVlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:41:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38431 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbZDDVlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:41:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NetDev <netdev@vger.kernel.org>
Subject: [RFT][PATCH 0/3] NET: Shutdown fixes for e1000, e1000e and ixgbe
Date: Sat, 4 Apr 2009 23:37:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904042337.31706.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 3fe7c4c9dca4fbbff92eb61a660690dad7029ec3 (net/igb: Fix kexec with igb
(rev. 3)) fixed a kexec problem with igb by making its shutdown routine only
put the device into a low power state if the system is going to be powered off.

The following three patches make analogous changes to e1000, e1000e and ixgbe.

Thanks,
Rafael

