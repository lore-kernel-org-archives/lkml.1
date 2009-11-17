Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZKQHcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZKQHcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZKQHcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:32:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54268 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZKQHcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:32:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Mark cifs mailing list as "moderated as non-subscribers"
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@samba.org>
In-Reply-To: <20091117162111.3DE8.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <20091117162111.3DE8.A69D9226@jp.fujitsu.com>
Message-Id: <20091117162808.3DEE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:32:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if non-subscribers post bug report to CIFS mailing list, they will get
following messages.

	Your mail to 'linux-cifs-client' with the subject

	    [PATCH x/x] cifs: xxxxxxxxxxxxx

	Is being held until the list moderator can review it for approval.

	The reason it is being held:

	    Post by non-member to a members-only list

	Either the message will get posted to the list, or you will receive
	notification of the moderator's decision.  If you would like to cancel
	this posting, please visit the following URL:

members-only list should be written as so in MAINTAINERS file.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 81d68d5..5c44047 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1418,8 +1418,8 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-L:	linux-cifs-client@lists.samba.org
-L:	samba-technical@lists.samba.org
+L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
+L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
-- 
1.6.2.5



