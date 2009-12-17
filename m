Return-Path: <linux-kernel-owner+w=401wt.eu-S1763218AbZLQEs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763218AbZLQEs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761822AbZLQEDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:03:43 -0500
Received: from kroah.org ([198.145.64.141]:55209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761812AbZLQEDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:35 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:44 2009
Message-Id: <20091217035644.018127687@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [008/151] perf_event: Fix invalid type in ioctl definition
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@infradead.org>

commit 4c49b12853fbb5eff4849b7b6a1e895776f027a1 upstream.

u64 is invalid in userspace headers, including ioctl
definitions; use __u64 instead

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20091113214733.7cd76be9@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/perf_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -219,7 +219,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_DISABLE		_IO ('$', 1)
 #define PERF_EVENT_IOC_REFRESH		_IO ('$', 2)
 #define PERF_EVENT_IOC_RESET		_IO ('$', 3)
-#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, u64)
+#define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 
 enum perf_event_ioc_flags {


