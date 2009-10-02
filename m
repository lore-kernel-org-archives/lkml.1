Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZJBJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZJBJRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbZJBJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:17:12 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:54840 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZJBJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=j1xPIE/7NNVImhuIX9TioQvqDOzLrszhzJgxrN5Vv2YN44r1BIHrnA68v3+70F4a4Z
         TdAXBaOsmL9wx3IinajvPsCwcXdvdUONSH8UFjgGvs5iGaCiqsL3DvMDGpFyU2XcgNbG
         6Wa6eZkX9ASU1HB5uqPbxbmoIZSRaNEwtXU8E=
Date: Fri, 2 Oct 2009 11:17:11 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Subject: Subject: [PATCH 2.4] Fix Kernel 2.4 build with bash 4
Message-ID: <20091002111711.5de3bf8f@strolchi>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.11; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stefan <stefan.seyfried@googlemail.com>
---
 scripts/Configure |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Configure b/scripts/Configure
index 1a3af43..7a73423 100644
--- a/scripts/Configure
+++ b/scripts/Configure
@@ -546,9 +546,9 @@ if [ -f $DEFAULTS ]; then
   echo "#"
   echo "# Using defaults found in" $DEFAULTS
   echo "#"
-  . $DEFAULTS
+  . ./$DEFAULTS
   sed -e 's/# \(CONFIG_[^ ]*\) is not.*/\1=n/' <$DEFAULTS >.config-is-not.$$
-  . .config-is-not.$$
+  . ./.config-is-not.$$
   rm .config-is-not.$$
 else
   echo "#"
-- 
1.6.4.2
