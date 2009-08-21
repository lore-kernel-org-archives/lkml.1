Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbZHURbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbZHURbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932131AbZHURbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:31:52 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:53275 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZHURbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:31:51 -0400
Date: Fri, 21 Aug 2009 09:58:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, Roland Dreier <rolandd@cisco.com>
Subject: [PATCH -mmotm] ummunotify: fix userspace build
Message-Id: <20090821095802.cae7136d.randy.dunlap@oracle.com>
In-Reply-To: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A8ED9E8.0069:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lots of build errors in ummunotify/umn-test, which are due to
this error:
Documentation/ummunotify/umn-test.c:23:30: error: linux/ummunotify.h: No such file or directory

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Roland Dreier <rolandd@cisco.com>
---
 Documentation/ummunotify/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0820-1918.orig/Documentation/ummunotify/Makefile
+++ mmotm-2009-0820-1918/Documentation/ummunotify/Makefile
@@ -4,4 +4,4 @@ hostprogs-y := umn-test
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_umn-test.o += -I$(objtree)/include
+HOSTCFLAGS_umn-test.o += -I$(objtree)/usr/include



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
