Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZFWLZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZFWLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZFWLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:25:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:32805 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbZFWLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:25:15 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: Andy Whitcroft <apw@canonical.com>, Mathias Urlichs <matthias@urlichs.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] BZ#11120: AACRAID driver stalls under high load
Date: Tue, 23 Jun 2009 12:25:05 +0100
Message-Id: <1245756306-29023-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.rc3.199.g24398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have had reports of driver stalls on AACRAID drivers under high load.  This
seems to be related to the ammount of concurrent IO that can be pushed
to the controller.  Reducing the maximum queue count for this driver sorts
this out.  For further details see the upstream and Ubuntu bugs:

    http://bugzilla.kernel.org/show_bug.cgi?id=11120
    http://bugs.launchpad.net/bugs/249964

Following this email is a patch from Mathias Urlichs to reduce the
queue size.  This has been tested and confirmed to fix the issue by a
couple of those affected.

Patches against Linus' tree.

-apw

Mathias Urlichs (1):
  Reduce AACRAID hardware queue size

 drivers/scsi/aacraid/aacraid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
