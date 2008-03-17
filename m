Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYCQRhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYCQRhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYCQRgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:36:51 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:60746 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276AbYCQRgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:36:50 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: grant.likely@secretlab.ca, git-dev@xilinx.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 0/3] Xilinx hwicap updates
Date: Mon, 17 Mar 2008 10:36:29 -0700
X-Mailer: git-send-email 1.5.3.4-dirty
Message-Id: <20080317173646.D512A1010058@mail4-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following sequence of patches makes the icap driver more robust,
by making better use of the status information from the cores.  In
addition, Lanana has assigned Major 259 for FPGA configuration
interfaces, so we now use it, rather than dynamically finding a major
number.

Grant: please pick these up for 2.6.26.  Do you think it's worth
patching virtex_devices.c at this point, or just punt on ARCH=ppc?

Steve


