Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbXHHSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbXHHSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXHHSgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:36:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33476 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXHHSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:36:16 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org
Subject: [PATCH 0/7] IB/ehca: support for user space small queues, support more than 4k queue pairs, generate last WQE reached
Date: Wed, 8 Aug 2007 20:36:11 +0200
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <Hoang-Nam.Nguyen@dyn-9-152-249-53>, fenkes@de.ibm.com,
       craisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082036.12684.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch set against Roland's git, branch for-2.6.23 for ehca.
It enables userspace support for small QP feature and make some fixes for it. 
Also there is add the mapping of 4k firmware context to user space.

They are in details:
[1/7] add support for userspace small queues and make some fixes
[2/7] ensure that a non-existing queues in case of SRQs are not interprete as 
small queues
[3/7] we have no longer to add 1 to the number of requestet wqes, because
firmware does now
[4/7] make changes to ehca_mmap() to support more than 4k queues 
[5/7] map 4k firmware context of cq, qp to user space
[6/7] generate last WQE reached, when base QP for SRQ has entered error state
[7/7] prevent overwriting QP init attributes given by caller

The patches should apply cleanly, in order, against Roland's git. Please
review the changes and apply the patches if they are okay.

Regards,
Stefan


