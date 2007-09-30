Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbXI3W5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbXI3W5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXI3W45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:56:57 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4799 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXI3W45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:56:57 -0400
Date: Sun, 30 Sep 2007 16:56:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v2 0/6] SystemACE: rework and of_platform bus binding patches
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       axboe@kernel.dk
Message-id: <20070930225112.2476.49914.stgit@trillian.cg.shawcable.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.12.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a set of rework patches on the Xilinx SystemACE driver which ends
in the addition of an of_platform bus binding.  The of_platform bus binding
is needed to use the driver from arch/powerpc.  SystemACE is most commonly
used in Xilinx Virtex system (ppc405).

Jens, I'm hoping I can get these changes in for 2.6.24.  Assuming nobody
raises any issues, can you please merge these into your tree?

Thanks,
g.

Grant Likely (6):
 Add Xilinx SystemACE entry to maintainers
 Sysace: Use the established platform bus api
 Sysace: Move structure allocation from bus binding into common code
 Sysace: minor rework and cleanup changes
 Sysace: Move IRQ handler registration to occur after FSM is initialized
 Sysace: Add of_platform_bus binding

 MAINTAINERS             |    7 ++
 drivers/block/xsysace.c |  249 +++++++++++++++++++++++++++++++++++-----------
       2 files changed, 196 insertions(+), 60 deletions(-)

--
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
