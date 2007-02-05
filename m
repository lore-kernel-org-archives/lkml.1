Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXBEN7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXBEN7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 08:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbXBEN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 08:59:31 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:32303 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbXBEN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 08:59:30 -0500
Date: Mon, 5 Feb 2007 15:59:12 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix the defaults mentioned in Documentation/nfsroot.txt
Message-ID: <20070205135911.GA4830@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch fixes the documentation of nfsroot to match NFS_DEF_FILE_IO_SIZE.

Or perhaps we need to change NFS_DEF_FILE_IO_SIZE to match the 
documentation?

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/Documentation/nfsroot.txt b/Documentation/nfsroot.txt
index 719f9a9..16a7cae 100644
--- a/Documentation/nfsroot.txt
+++ b/Documentation/nfsroot.txt
@@ -67,8 +67,8 @@ nfsroot=[<server-ip>:]<root-dir>[,<nfs-o
   <nfs-options>	Standard NFS options. All options are separated by commas.
 		The following defaults are used:
 			port		= as given by server portmap daemon
-			rsize		= 1024
-			wsize		= 1024
+			rsize		= 4096
+			wsize		= 4096
 			timeo		= 7
 			retrans		= 3
 			acregmin	= 3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
