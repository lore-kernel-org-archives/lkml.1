Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYFIPmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYFIPmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbYFIPmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:42:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37321 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYFIPml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:42:41 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       general@lists.openfabrics.org, "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Prevent loss of interrupts in IB/ehca
Date: Mon, 9 Jun 2008 17:42:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       THEMANN@de.ibm.com, TKLEIN@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091742.29421.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains two changes for IB/ehca and ibmebus.

The first patch enables ibmebus_request_irq() to optionally return the 
IRQ number, which is used by the second patch to trigger EOI in case of 
lost interrupts.

They should apply cleanly against 2.6.26 git tree.

Thanks
Stefan
