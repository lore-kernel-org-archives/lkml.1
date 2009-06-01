Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZFAV56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZFAV56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZFAVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:52:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35914 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbZFAVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:51:01 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Date: Mon,  1 Jun 2009 14:50:44 -0700
Message-Id: <1243893048-17031-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.3.1.54.g99dd.dirty
In-Reply-To: <m1oct739xu.fsf@fess.ebiederm.org>
References: <m1oct739xu.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org, adobriyan@gmail.com, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de, akpm@linux-foundation.org, hch@infradead.org, ebiederm@maxwell.aristanetworks.com, ebiederm@aristanetworks.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 19/23] eventpoll: Fix comment
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index eabb167..d42071d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -62,7 +62,7 @@
  * This mutex is acquired by ep_free() during the epoll file
  * cleanup path and it is also acquired by eventpoll_release_file()
  * if a file has been pushed inside an epoll set and it is then
- * close()d without a previous call toepoll_ctl(EPOLL_CTL_DEL).
+ * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
  * It is possible to drop the "ep->mtx" and to use the global
  * mutex "epmutex" (together with "ep->lock") to have it working,
  * but having "ep->mtx" will make the interface more scalable.
-- 
1.6.3.1.54.g99dd.dirty

