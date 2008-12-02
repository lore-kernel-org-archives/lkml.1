Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYLBVsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYLBVsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYLBVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:48:27 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58482 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYLBVsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:48:25 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: [PATCH 0/6] integrity 
Date: Tue,  2 Dec 2008 16:47:54 -0500
Message-Id: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the LIM and IMA integrity system patches.
To address concerns raised on the mailing list of the IMA patch
size, the IMA patch has been broken up into three smaller patches
for easier review.

1 - TPM internal interfaces (unchanged)
2 - LIM - (minor cleanup)
3 - IMA - Main (updates in response to comments)
4 - IMA - securityfs - display (unchanged)
5 - IMA - securityfs - policy (unchanged)
6 - (credential patch for security-testing-2.6/next)

The first five patches apply cleanly to linux-2.6.28-rc6 and with minor
offsets to security-testing-2.6/#next. The last patch addresses the
security-testing-2.6/#next credential merge issues.

Mimi Zohar (6):
  integrity: TPM internel kernel interface
  integrity: Linux Integrity Module(LIM)
  integrity: IMA as an integrity service provider
  integrity: IMA display
  integrity: IMA policy
  integrity: replace task uid with cred uid
