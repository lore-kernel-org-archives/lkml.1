Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYKTQoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYKTQoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYKTQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:44:20 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55886 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbYKTQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:44:19 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: [PATCH 0/4] integrity 
Date: Thu, 20 Nov 2008 11:43:02 -0500
Message-Id: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first three patches address concerns raised on the mailing
list.  They apply cleanly to linux-2.6.28-rc5 and with minor
offsets to security-testing-2.6/#next. The last patch is only
for the security-testing-2.6/#next tree. It addresses credential
merge issues.

- Merges the integrity radix tree patch into the existing integrity
  patches.
- Replaces integrity_nameidata_check() with integrity_path_check().
- Cleans up tget/tput callers and removed the null pointer test.
- Replaces remaining GFP_ATOMIC alloc with GFP_KERNEL.
- Replaces ima_iint_init() with RADIX_TREE macro.

Mimi Zohar (4):
  integrity: TPM internel kernel interface
  integrity: Linux Integrity Module(LIM)
  integrity: IMA as an integrity service provider
  integrity: replace task uid with cred uid
