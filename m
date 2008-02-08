Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbYBHQwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbYBHQwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763261AbYBHQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:51:24 -0500
Received: from vena.lwn.net ([206.168.112.25]:37777 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763242AbYBHQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:51:21 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/patch-tags, one more time
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
From: Jonathan Corbet <corbet@lwn.net>
Date: Fri, 08 Feb 2008 09:51:19 -0700
Message-ID: <9525.1202489479@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somebody recently asked me about this patch, so I dug it up for one last
try.  I do believe there is value in describing patch tags, and,
certainly, nobody has objected to the idea.  Comments from several
reviewers were addressed before the previous posting.

jon

--

Add a document describing the various tags attached to patches.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/00-INDEX   |    2 +
 Documentation/patch-tags |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/patch-tags

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 6e9c405..a900a6d 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -289,6 +289,8 @@ parport.txt
 	- how to use the parallel-port driver.
 parport-lowlevel.txt
 	- description and usage of the low level parallel port functions.
+patch-tags
+	- description of the tags which can be added to patches
 pci-error-recovery.txt
 	- info on PCI error recovery.
 pci.txt
diff --git a/Documentation/patch-tags b/Documentation/patch-tags
new file mode 100644
index 0000000..c2fb56c
--- /dev/null
+++ b/Documentation/patch-tags
@@ -0,0 +1,76 @@
+Patches headed for the mainline may contain a variety of tags documenting
+who played a hand in (or was at least aware of) their progress.  All of
+these tags have the form:
+
+	Something-done-by: Full name <email@address> [optional random stuff]
+
+These tags are:
+
+From: 	   	The original author of the patch.  This tag will ensure
+		that credit is properly given when somebody other than the
+		original author submits the patch.
+
+Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
+		patch, to the best of his or her knowledge, can legally be
+		merged into the mainline and distributed under the terms of
+		the GNU General Public License, version 2.  See the
+		Developer's Certificate of Origin, found in
+		Documentation/SubmittingPatches, for the precise meaning of
+		Signed-off-by.  This tag assures upstream maintainers that
+		the provenance of the patch is known and allows the origin
+		of the patch to be reviewed should copyright questions
+		arise.
+
+Acked-by:	The person named (who should be an active developer in the
+		area addressed by the patch) is aware of the patch and has
+		no objection to its inclusion; it informs upstream
+		maintainers that a certain degree of consensus on the patch
+		as been achieved..  An Acked-by tag does not imply any
+		involvement in the development of the patch or that a
+		detailed review was done. 
+
+Reviewed-by:	The patch has been reviewed and found acceptable according
+		to the Reviewer's Statement as found at the bottom of this
+		file.  A Reviewed-by tag is a statement of opinion that the
+		patch is an appropriate modification of the kernel without
+		any remaining serious technical issues.  Any interested
+		reviewer (who has done the work) can offer a Reviewed-by
+		tag for a patch.  This tag serves to give credit to
+		reviewers and to inform maintainers of the degree of review
+		which has been done on the patch.
+
+Cc:		The person named was given the opportunity to comment on
+		the patch.  This is the only tag which might be added
+		without an explicit action by the person it names.  This
+		tag documents that potentially interested parties have been
+		included in the discussion.
+
+Tested-by:	The patch has been successfully tested (in some
+		environment) by the person named.  This tag informs
+		maintainers that some testing has been performed, provides
+		a means to locate testers for future patches, and ensures
+		credit for the testers.
+
+
+----
+
+Reviewer's statement of oversight
+
+By offering my Reviewed-by: tag, I state that:
+
+ (a) I have carried out a technical review of this patch to evaluate its
+     appropriateness and readiness for inclusion into the mainline kernel. 
+
+ (b) Any problems, concerns, or questions relating to the patch have been
+     communicated back to the submitter.  I am satisfied with the
+     submitter's response to my comments.
+
+ (c) While there may be things that could be improved with this submission,
+     I believe that it is, at this time, (1) a worthwhile modification to
+     the kernel, and (2) free of known issues which would argue against its
+     inclusion.
+
+ (d) While I have reviewed the patch and believe it to be sound, I do not
+     (unless explicitly stated elsewhere) make any warranties or guarantees
+     that it will achieve its stated purpose or function properly in any
+     given situation.
-- 
1.5.4

