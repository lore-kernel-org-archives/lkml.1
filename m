Return-Path: <linux-kernel-owner+w=401wt.eu-S1762890AbXGTNhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbXGTNhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXGTNhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:37:13 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:6403 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbXGTNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:37:10 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: rolandd@cisco.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org
Subject: [PATCH 0/5] ehca: MR large page, small queue and fixes
Date: Fri, 20 Jul 2007 15:48:35 +0200
User-Agent: KMail/1.8.2
Cc: stefan.roscher@de.ibm.com, raisch@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201548.36047.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch set against Roland's git, branch for-2.6.23 for ehca.
It adds support for MR large page and small queues. In addition of that
it also contains various small fixes from previous comments and what
we found.

They are in details:
[1/5] adds support for MR large page
[2/5] generates event when SRQ limit reached
[3/5] makes ehca2ib_return_code() non inline
[4/5] makes internal_create/destroy_qp() static
[5/5] adds support for small queues

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches if they are okay.

Regards,
Nam & Stefan

