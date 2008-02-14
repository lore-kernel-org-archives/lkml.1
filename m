Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYBNTat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYBNTat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYBNTal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:30:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:64560 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbYBNTak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:30:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VZa66eE+cgVWSr0bLlg5LUfiDjgFQEH+7RfM5+VlGhN3dZQU1gpaLW8yKlTH0wU4J8/hLvSBfJN/KkQK90pECIMiU+cv7JzMRqxdH2ssxQqGPb+g1Yfd9CjRrcuDHby8KflEcqbEVoXOf3kf3peBXH/VOYN1LHIsWckxzVLk1dY=
Subject: [PATCH] kernel-doc: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 11:30:37 -0800
Message-Id: <1203017437.2748.73.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall is gone from the tree, no need to adjust the function
prototypes anymore for this.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 scripts/kernel-doc |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 6c18a14..26146cb 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1624,7 +1624,6 @@ sub dump_function($$) {
 
     $prototype =~ s/^static +//;
     $prototype =~ s/^extern +//;
-    $prototype =~ s/^fastcall +//;
     $prototype =~ s/^asmlinkage +//;
     $prototype =~ s/^inline +//;
     $prototype =~ s/^__inline__ +//;
-- 
1.5.4.1.1278.gc75be


