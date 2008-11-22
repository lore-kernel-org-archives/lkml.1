Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYKVRe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYKVRe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYKVReQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995AbYKVReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 6/32] istallion section warnings
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wN4-0006LC-Ie@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


stli_findeisabrds() and stli_initbrds() are using __init and called only
from __init.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/istallion.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -3739,7 +3739,7 @@ static int stli_getbrdnr(void)
  *	do is go probing around in the usual places hoping we can find it.
  */
 
-static int stli_findeisabrds(void)
+static int __init stli_findeisabrds(void)
 {
 	struct stlibrd *brdp;
 	unsigned int iobase, eid, i;
@@ -3935,7 +3935,7 @@ static struct stlibrd *stli_allocbrd(void)
  *	can find.
  */
 
-static int stli_initbrds(void)
+static int __init stli_initbrds(void)
 {
 	struct stlibrd *brdp, *nxtbrdp;
 	struct stlconf conf;
