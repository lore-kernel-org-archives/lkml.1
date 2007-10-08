Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbXJHWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbXJHWnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXJHWnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:43:12 -0400
Received: from vena.lwn.net ([206.168.112.25]:35378 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbXJHWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:43:11 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: reviewer's statement of oversight 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 08 Oct 2007 19:37:07 +0200."
             <20071008173706.GA12026@uranus.ravnborg.org> 
Date: Mon, 08 Oct 2007 16:43:10 -0600
Message-ID: <10940.1191883390@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> Or maybe we need something much less formal that explain the purpose of the
> four tags we use:

...or maybe a combination?  How does the following patch look as a way
to describe how the tags are used and what Reviewed-by, in particular,
means?

Perhaps the DCO should move to this file as well?

jon

---

Add a document on patch tags.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 43e89b1..fa1518b 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -284,6 +284,8 @@ parport.txt
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
index 0000000..fb5f8e1
--- /dev/null
+++ b/Documentation/patch-tags
@@ -0,0 +1,66 @@
+Patches headed for the mainline may contain a variety of tags documenting
+who played a hand in (or was at least aware of) its progress.  All of these
+tags have the form:
+
+	Something-done-by: Full name <email@address>
+
+These tags are:
+
+Signed-off-by:  A person adding a Signed-off-by tag is attesting that the
+		patch is, to the best of his or her knowledge, legally able
+		to be merged into the mainline and distributed under the
+		terms of the GNU General Public License, version 2.  See
+		the Developer's Certificate of Origin, found in
+		Documentation/SubmittingPatches, for the precise meaning of
+		Signed-off-by.
+
+Acked-by:	The person named (who should be an active developer in the
+		area addressed by the patch) is aware of the patch and has
+		no objection to its inclusion.  An Acked-by tag does not
+		imply any involvement in the development of the patch or
+		that a detailed review was done.
+
+Reviewed-by:	The patch has been reviewed and found acceptible according
+		to the Reviewer's Statement as found at the bottom of this
+		file.  A Reviewed-by tag is a statement of opinion that the
+		patch is an appropriate modification of the kernel without
+		any remaining serious technical issues.  Any interested
+		reviewer (who has done the work) can offer a Reviewed-by
+		tag for a patch.
+
+Cc:		The person named was given the opportunity to comment on
+		the patch.  This is the only tag which might be added
+		without an explicit action by the person it names.
+
+Tested-by:	The patch has been successfully tested (in some
+		environment) by the person named.
+
+
+----
+
+Reviewer's statement of oversight, v0.02
+
+By offering my Reviewed-by: tag, I state that:
+
+ (a) I have carried out a technical review of this patch to evaluate its
+     appropriateness and readiness for inclusion into the mainline kernel. 
+
+ (b) Any problems, concerns, or questions relating to the patch have been
+     communicated back to the submitter.  I am satisfied with how the
+     submitter has responded to my comments.
+
+ (c) While there may (or may not) be things which could be improved with
+     this submission, I believe that it is, at this time, (1) a worthwhile
+     modification to the kernel, and (2) free of known issues which would
+     argue against its inclusion.
+
+ (d) While I have reviewed the patch and believe it to be sound, I can not
+     (unless explicitly stated elsewhere) make any warranties or guarantees
+     that it will achieve its stated purpose or function properly in any
+     given situation.
+
+ (e) I understand and agree that this project and the contribution are
+     public and that a record of the contribution (including my Reviewed-by
+     tag and any associated public communications) is maintained
+     indefinitely and may be redistributed consistent with this project or
+     the open source license(s) involved.
