Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbZE0O7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbZE0O7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZE0O7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:59:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52076 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZE0O7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:59:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 0/2] kvm: validate irqfd type
To: mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Date: Wed, 27 May 2009 10:36:55 -0400
Message-ID: <20090527143251.14024.89090.stgit@dev.haskins.net>
In-Reply-To: <4A1D48FA.9080403@novell.com>
References: <4A1D48FA.9080403@novell.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tsirkin pointed out an issue in kvm.git w.r.t. malicious userspace
configuring irqfd objects:

http://lkml.org/lkml/2009/5/27/341

This series applies to kvm.git/master:1a6a35a1 to attempt to close the
vulnerability.

---

Gregory Haskins (2):
      kvm: validate irqfd type
      eventfd: export eventfd interfaces for module use


 fs/eventfd.c       |    3 +++
 virt/kvm/eventfd.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

-- 
Signature
