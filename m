Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYHLNqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYHLNqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYHLNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:24 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:62189 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbYHLNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:23 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 0/5 try2] ib/ehca: Fix stability issues
Date: Tue, 12 Aug 2008 15:46:00 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200808121546.00211.alexs@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

Sorry, the first set was mangled because of a broken mailer, so here it is
again, double checked...

the following patchset contains four small fixes and one bigger patch
(5/5) for addressing some ehca issues we found during cluster test.

[1/5] update qp_state on cached modify_qp()
[2/5] rename goto label in ehca_poll_cq_one()
[3/5] repoll on invalid opcode instead of returning success
[4/5] check idr_find() return value
[5/5] discard double CQE for one WR

They all apply on top of 2.6.27-rc1. If possible, we would like to get
them into 2.6.27.

Regards,
Alexander Schmidt
