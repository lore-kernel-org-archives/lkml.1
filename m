Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbZLOSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbZLOSdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbZLOSdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:33:32 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:49323 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299AbZLOSdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:33:31 -0500
Message-ID: <4B27D658.8000601@oracle.com>
Date: Tue, 15 Dec 2009 10:32:56 -0800
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk
CC: Mark Fasheh <mfasheh@suse.com>, Joel Becker <Joel.Becker@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [Fwd: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED]
Content-Type: multipart/mixed;
 boundary="------------060906080604000600040507"
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4B27D667.018B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060906080604000600040507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew / Christoph / Al,

Please could I get an Ack for this patch. It adds a FIEMAP flag
to denote shared extents.

Thanks
Sunil

--------------060906080604000600040507
Content-Type: message/rfc822;
 name="[Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP";
 filename*1="_EXTENT_SHARED.eml"

Received: from acsinet15.oracle.com (/141.146.126.227)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 03 Dec 2009 12:47:23 -0800
Received: from oss.oracle.com (oss.oracle.com [141.146.12.120])
	by acsinet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id nB3KlS3T012110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Thu, 3 Dec 2009 20:47:28 GMT
Received: from localhost ([127.0.0.1] helo=oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1NGIa4-0006D9-F3; Thu, 03 Dec 2009 12:47:16 -0800
Received: from rcsinet13.oracle.com ([148.87.113.125]
	helo=rgminet13.oracle.com) by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <smushran@ca-server1.us.oracle.com>)
	id 1NGIZn-0006C0-Bg
	for ocfs2-devel@oss.oracle.com; Thu, 03 Dec 2009 12:46:59 -0800
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by rgminet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id
	nB36GP6A027861; Thu, 3 Dec 2009 20:46:58 GMT
Received: from ca-server1.us.oracle.com by acsmt354.oracle.com
	with ESMTP id 784177551259873213; Thu, 03 Dec 2009 12:46:53 -0800
Received: from smushran by ca-server1.us.oracle.com with local (Exim 4.69)
	(envelope-from <smushran@ca-server1.us.oracle.com>)
	id 1NGIZg-00077e-IN; Thu, 03 Dec 2009 12:46:52 -0800
From: Sunil Mushran <sunil.mushran@oracle.com>
To: akpm@linux-foundation.org
Date: Thu,  3 Dec 2009 12:46:51 -0800
Message-Id: <1259873212-20107-2-git-send-email-sunil.mushran@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
References: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
X-Source-IP: oss.oracle.com [141.146.12.120]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B1823D9.01B6:SCFSTAT3865452,ss=1,fgs=0
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag
	FIEMAP_EXTENT_SHARED
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com

Patch adds flag FIEMAP_EXTENT_SHARED to denote extents that are
shared with other inodes.

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/fiemap.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fiemap.h b/include/linux/fiemap.h
index 934e22d..d830747 100644
--- a/include/linux/fiemap.h
+++ b/include/linux/fiemap.h
@@ -62,5 +62,7 @@ struct fiemap {
 #define FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
 						    * support extents. Result
 						    * merged for efficiency. */
+#define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with other
+						    * files. */
 
 #endif /* _LINUX_FIEMAP_H */
-- 
1.5.6.5


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel

--------------060906080604000600040507--
