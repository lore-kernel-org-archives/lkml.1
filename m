Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZIRQvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZIRQvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZIRQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:51:15 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38651 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbZIRQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:51:13 -0400
Date: Fri, 18 Sep 2009 09:49:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH -mmotm] cred: export creds_are_invalid
Message-Id: <20090918094935.40e6fccf.randy.dunlap@oracle.com>
In-Reply-To: <200909180122.n8I1Mr83020524@imap1.linux-foundation.org>
References: <200909180122.n8I1Mr83020524@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AB3BA22.00E3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

creds_are_invalid() needs to be exported for use by modules:

ERROR: "creds_are_invalid" [fs/cachefiles/cachefiles.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Howells <dhowells@redhat.com>
---
 kernel/cred.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2009-0917-1800.orig/kernel/cred.c
+++ mmotm-2009-0917-1800/kernel/cred.c
@@ -799,6 +799,7 @@ bool creds_are_invalid(const struct cred
 #endif
 	return false;
 }
+EXPORT_SYMBOL(creds_are_invalid);
 
 /*
  * dump invalid credentials



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
