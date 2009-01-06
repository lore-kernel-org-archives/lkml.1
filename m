Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZAFWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZAFWRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbZAFWNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:30 -0500
Received: from kroah.org ([198.145.64.141]:51197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755270AbZAFWN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/60] kobject: Make Documentation/kobject.txt a little more coherent.
Date: Tue,  6 Jan 2009 14:11:30 -0800
Message-Id: <1231279939-32728-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

While reading Documentation/kobject.txt:

  Note kobject_rename does perform any locking or have a solid notion of
  what names are valid so the provide must provide their own sanity checking
  and serialization.

I expect better: You never see me hard with time word making sentence
coherent stuff.  Ever.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kobject.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index f5d2aad..b2e3745 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -118,8 +118,8 @@ the name of the kobject, call kobject_rename():
 
     int kobject_rename(struct kobject *kobj, const char *new_name);
 
-Note kobject_rename does perform any locking or have a solid notion of
-what names are valid so the provide must provide their own sanity checking
+kobject_rename does not perform any locking or have a solid notion of
+what names are valid so the caller must provide their own sanity checking
 and serialization.
 
 There is a function called kobject_set_name() but that is legacy cruft and
-- 
1.6.0.4

