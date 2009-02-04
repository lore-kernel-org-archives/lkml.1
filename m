Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZBDOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZBDOTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZBDOTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:19:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55375 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZBDOT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:19:29 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/7] integrity 
Date: Wed,  4 Feb 2009 09:06:56 -0500
Message-Id: <cover.1233750611.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the IMA integrity patches. The changes made since
the last integrity posting are based on comments made by James Morris and
Serge Hallyn.
- removed test for NULL return code from securityfs_create_file/dir
- alloc ima_template_entry before calling ima_store_template()
- log ima_add_boot_aggregate failure
- free invalid rule
- add hook to increment opencount for /dev/zero shm
- replaced hard coded string length with #define name
- removed unused IMA_TEMPLATE_NAME_LEN

This patchset is dependent on the tpm-integrity-interface patch, which
has been applied to the security-testing-2.6/#next.

Mimi Zohar (7):
  integrity: IMA hooks
  integrity: IMA as an integrity service provider
  integrity: IMA display
  integrity: IMA policy
  integrity: IMA policy open
  Integrity: IMA file free imbalance
  Integrity: IMA update maintainers
