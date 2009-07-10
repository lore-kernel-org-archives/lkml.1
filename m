Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZGJXAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZGJXAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 19:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZGJXAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 19:00:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZGJXAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 19:00:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:x-system-of-record;
	b=I4eh+T8ODDXvd7RH+POXw8oJeM+ih90R6YT0dyGbOPZCm3k/fRe9gdvhy0WfdgcyW
	5M9+s0/r1zwtfz7WS9v3w==
From: Ben Blum <bblum@google.com>
Subject: [PATCH 0/3] Series short description
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
Date: Fri, 10 Jul 2009 15:59:45 -0700
Message-ID: <20090710225343.15970.42287.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements...

---

Ben Blum (3):
      Quick vmalloc vs kmalloc fix to the case where array size > KMALLOC_MAX_SIZE
      Ensures correct concurrent opening/reading of pidlists across pid namespaces
      Adds a read-only "procs" file similar to "tasks" that shows only unique tgids


 include/linux/cgroup.h |   46 +++++-
 kernel/cgroup.c        |  378 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 309 insertions(+), 115 deletions(-)

