Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbYHLMvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbYHLMvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYHLMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:50:39 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:42661 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYHLMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:50:37 -0400
Date: Tue, 12 Aug 2008 14:49:24 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: [PATCH 0/5] ib/ehca: Fix stability issues
Message-ID: <20080812144924.4447933e@BL3D1974.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

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
