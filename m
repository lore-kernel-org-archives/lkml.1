Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZACEby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZACEby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZACEbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:31:44 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43655 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZACEbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:31:43 -0500
Date: Fri, 2 Jan 2009 20:30:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] jbd: remove excess kernel-doc notation
Message-Id: <20090102203028.20f51fc1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.495EEA22.004A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Remove excess kernel-doc from fs/jbd/transaction.c:

Warning(linux-2.6.28-git5//fs/jbd/transaction.c:764): Excess function parameter 'credits' description in 'journal_get_write_access'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/jbd/transaction.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.28-git5.orig/fs/jbd/transaction.c
+++ linux-2.6.28-git5/fs/jbd/transaction.c
@@ -752,7 +752,6 @@ out:
  * int journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
  * @handle: transaction to add buffer modifications to
  * @bh:     bh to be used for metadata writes
- * @credits: variable that will receive credits for the buffer
  *
  * Returns an error code or 0 on success.
  *
