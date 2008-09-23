Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYIWRUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYIWRUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYIWRTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:19:55 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:33586 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYIWRTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:19:54 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmoriss@namei.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       paulmck@linux.vnet.ibm.com, debora@linux.vnet.ibm.com
Subject: [PATCH 0/4] BKL removed, RCU addition and pnp remove
Date: Tue, 23 Sep 2008 14:19:25 -0300
Message-Id: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Removes unnecessary BKL from tpm.c
2) Changes the num_opens variable name to is_open since it's a binary
state
3) Implements the use of RCU to protect tpm_chip_list
4) Insert .remove function in tis_pnp_driver structure

  TPM: update char dev BKL pushdown
  TPM: num_opens to is_open variable change
  TPM: rcu locking
  TPM: pnp remove

 drivers/char/tpm/tpm.c     |   91 +++++++++++++++++++++-----------------------
 drivers/char/tpm/tpm.h     |    3 +-
 drivers/char/tpm/tpm_tis.c |   14 ++++++-
 3 files changed, 58 insertions(+), 50 deletions(-)

