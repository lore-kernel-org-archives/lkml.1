Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYKURm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYKURm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYKURmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:42:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53062 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYKURmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:42:16 -0500
Subject: Re: [PATCH 0/4] integrity
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@liux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
In-Reply-To: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 09:42:10 -0800
Message-Id: <1227289331.11607.34.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My worry:

	36 files changed, 3250 insertions(+), 14 deletions(-)

Can you find any better way to split this up?  79k is still pretty huge
for one patch.  Were you just trying to get under the LKML limit? ;)

 Documentation/kernel-parameters.txt    |    5 
 b/Documentation/ABI/testing/ima_policy |   61 ++++
 b/Documentation/kernel-parameters.txt  |    6 
 b/drivers/char/tpm/tpm.c               |  140 +++++++++
 b/drivers/char/tpm/tpm.h               |    4 
 b/drivers/char/tpm/tpm_tis.c           |    3 
 b/fs/exec.c                            |    7 
 b/fs/file_table.c                      |    3 
 b/fs/inode.c                           |   22 +
 b/fs/namei.c                           |    6 
 b/include/linux/audit.h                |    5 
 b/include/linux/ima.h                  |   46 +++
 b/include/linux/integrity.h            |  166 +++++++++++
 b/include/linux/tpm.h                  |   49 +++
 b/mm/mmap.c                            |    4 
 b/security/Kconfig                     |    2 
 b/security/Makefile                    |    4 
 b/security/integrity/Kconfig           |   24 +
 b/security/integrity/Makefile          |    6 
 b/security/integrity/ima/Kconfig       |   48 +++
 b/security/integrity/ima/Makefile      |    9 
 b/security/integrity/ima/ima.h         |  198 +++++++++++++
 b/security/integrity/ima/ima_api.c     |  420 ++++++++++++++++++++++++++++
 b/security/integrity/ima/ima_crypto.c  |  149 ++++++++++
 b/security/integrity/ima/ima_fs.c      |  488 +++++++++++++++++++++++++++++++++
 b/security/integrity/ima/ima_iint.c    |   63 ++++
 b/security/integrity/ima/ima_init.c    |  105 +++++++
 b/security/integrity/ima/ima_main.c    |  331 ++++++++++++++++++++++
 b/security/integrity/ima/ima_policy.c  |  336 ++++++++++++++++++++++
 b/security/integrity/ima/ima_queue.c   |  124 ++++++++
 b/security/integrity/integrity.c       |  313 +++++++++++++++++++++
 b/security/integrity/integrity.h       |   30 ++
 b/security/integrity/integrity_audit.c |   81 +++++
 security/Kconfig                       |    3 
 security/integrity/Kconfig             |    2 
 security/integrity/Makefile            |    1 
 36 files changed, 3250 insertions(+), 14 deletions(-)

-- Dave

