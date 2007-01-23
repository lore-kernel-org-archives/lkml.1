Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbXAWXNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbXAWXNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 18:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXAWXNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 18:13:38 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62393 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965586AbXAWXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 18:13:37 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, hch@infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, openfabrics-ewg@openib.org
Subject: [PATCH 2.6.21 0/4] ehca: remove do_mmap() and some bug fixes
Date: Wed, 24 Jan 2007 00:09:56 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701240009.57364.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland!
Here is a patch set for ehca as a result of previous disscussions
and comments:
1. fix improper use of yield within spinlock context
2. fix mismatched use of spin_unlock in irq handler
3. remove do_mmap()
4. remove obsolete prototypes
PS: I've sent the first two recently for 2.6.20, but adding here
for completeness for 2.6.21.
Thanks
Nam
