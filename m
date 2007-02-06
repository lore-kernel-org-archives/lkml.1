Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXBFQFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXBFQFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbXBFQFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:05:01 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:58148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbXBFQE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:04:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=S6HRP6W1eSyp6p4sY/mOKnkOJWjLj7Q5lPZVSNyOSA42EmiYnw4ovFgzldnreEt4wAhQGm69bRyKH58Bp4ISs62LkTBJqQsXn27qLfOvIaSAntgS+na2GTxQ+O5IDXN0cLmn1xQ2bF2rbLW4WHMrb2ZcdHRi10nQsHkVvNsJ0jc=
Date: Tue, 6 Feb 2007 18:04:46 +0200
To: kkeil@suse.de, kai.germaschewski@gmx.de
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160446.GE8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
 capi.c    |    4 ++--
 capidrv.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index d22c022..3804591 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1456,7 +1456,7 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=0; i < nelem; i++) {
@@ -1468,7 +1468,7 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=nelem-1; i >= 0; i--) {
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index c4d438c..8cec9c3 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2218,7 +2218,7 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=0; i < nelem; i++) {
@@ -2230,7 +2230,7 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
+    int nelem = ARRAY_SIZE(procfsentries);
     int i;
 
     for (i=nelem-1; i >= 0; i--) {

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
