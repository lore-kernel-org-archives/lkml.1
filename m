Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZDUPPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZDUPPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZDUPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:15:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46289 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbZDUPPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:15:36 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 0/3] IB/ehca: Perfomance improvment for creation of queue pairs
Date: Tue, 21 Apr 2009 17:15:32 +0200
User-Agent: KMail/1.9.9
Cc: raisch@de.ibm.com, fenkes@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@qde.ibm.com, hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211715.32625.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains performance improvments for ehca driver.
It will skip code which is not necessary for userspace queue pairs
and will replace vmalloc() calls with kmalloc().
Because of this fundamental code change we will also increment the version number.

They should apply cleanly against 2.6.30 git tree.

Thanks
Stefan
