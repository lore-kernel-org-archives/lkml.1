Return-Path: <linux-kernel-owner+w=401wt.eu-S936236AbYBUXwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936236AbYBUXwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935653AbYBUXsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:40 -0500
Received: from ns1.suse.de ([195.135.220.2]:45041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935491AbYBUXsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/11] stable_kernel_rules: fix must already be in mainline
Date: Thu, 21 Feb 2008 15:48:03 -0800
Message-Id: <1203637687-7273-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

stable_kernel_rules: fix must already be in mainline

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/stable_kernel_rules.txt |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/stable_kernel_rules.txt b/Documentation/stable_kernel_rules.txt
index c815c52..4cfc788 100644
--- a/Documentation/stable_kernel_rules.txt
+++ b/Documentation/stable_kernel_rules.txt
@@ -16,8 +16,9 @@ Rules on what kind of patches are accepted, and which ones are not, into the
    race can be exploited is also provided.
  - It cannot contain any "trivial" fixes in it (spelling changes,
    whitespace cleanups, etc).
- - It must be accepted by the relevant subsystem maintainer.
  - It must follow the Documentation/SubmittingPatches rules.
+ - It or an equivalent fix must already exist in Linus' tree.  Quote the
+   respective commit ID in Linus' tree in your patch submission to -stable.
 
 
 Procedure for submitting patches to the -stable tree:
@@ -28,7 +29,9 @@ Procedure for submitting patches to the -stable tree:
    queue, or a NAK if the patch is rejected.  This response might take a few
    days, according to the developer's schedules.
  - If accepted, the patch will be added to the -stable queue, for review by
-   other developers.
+   other developers and by the relevant subsystem maintainer.
+ - If the stable@kernel.org address is added to a patch, when it goes into
+   Linus's tree it will automatically be emailed to the stable team.
  - Security patches should not be sent to this alias, but instead to the
    documented security@kernel.org address.
 
-- 
1.5.4

