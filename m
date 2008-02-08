Return-Path: <linux-kernel-owner+w=401wt.eu-S964937AbYBHUmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937AbYBHUmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYBHUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:42:24 -0500
Received: from vena.lwn.net ([206.168.112.25]:50723 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbYBHUmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:42:23 -0500
To: Paul Jackson <pj@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Documenting patch tags yet one more time
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 08 Feb 2008 13:01:26 CST."
             <20080208130126.e05be25d.pj@sgi.com> 
Date: Fri, 08 Feb 2008 13:42:22 -0700
Message-ID: <27099.1202503342@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, Linus questioned the From: tag, so I've just taken that out for
now.   Paul Jackson asked:

> Question -- should this documentation of patch-tags be in its own file,
> or added to Documentation/SubmittingPatches.

Clearly I had once thought the former, but, on review, I've changed my
mind.  So here's a version which merges the information into
SubmittingPatches instead.

Thanks,

jon

--
Add documentation for more patch tags

Add documentation of the Cc:, Tested-by:, and Reviewed-by: tags to
SubmittingPatches, with an emphasis on trying to nail down what
Reviewed-by: really means.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 08a1ed1..cc00c8e 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -328,7 +328,7 @@ now, but you can do this to mark internal company procedures or just
 point out some special detail about the sign-off. 
 
 
-13) When to use Acked-by:
+13) When to use Acked-by: and Cc:
 
 The Signed-off-by: tag indicates that the signer was involved in the
 development of the patch, or that he/she was in the patch's delivery path.
@@ -349,11 +349,59 @@ Acked-by: does not necessarily indicate acknowledgement of the entire patch.
 For example, if a patch affects multiple subsystems and has an Acked-by: from
 one subsystem maintainer then this usually indicates acknowledgement of just
 the part which affects that maintainer's code.  Judgement should be used here.
- When in doubt people should refer to the original discussion in the mailing
+When in doubt people should refer to the original discussion in the mailing
 list archives.
 
+If a person has had the opportunity to comment on a patch, but has not
+provided such comments, you may optionally add a "Cc:" tag to the patch.
+This is the only tag which might be added without an explicit action by the
+person it names.  This tag documents that potentially interested parties
+have been included in the discussion
 
-14) The canonical patch format
+
+14) Using Test-by: and Reviewed-by:
+
+A Tested-by: tag indicates that the patch has been successfully tested (in
+some environment) by the person named.  This tag informs maintainers that
+some testing has been performed, provides a means to locate testers for
+future patches, and ensures credit for the testers.
+
+Reviewed-by:, instead, indicates that the patch has been reviewed and found
+acceptable according to the Reviewer's Statement:
+
+	Reviewer's statement of oversight
+
+	By offering my Reviewed-by: tag, I state that:
+
+ 	 (a) I have carried out a technical review of this patch to
+	     evaluate its appropriateness and readiness for inclusion into
+	     the mainline kernel.
+
+	 (b) Any problems, concerns, or questions relating to the patch
+	     have been communicated back to the submitter.  I am satisfied
+	     with the submitter's response to my comments.
+
+	 (c) While there may be things that could be improved with this
+	     submission, I believe that it is, at this time, (1) a
+	     worthwhile modification to the kernel, and (2) free of known
+	     issues which would argue against its inclusion.
+
+	 (d) While I have reviewed the patch and believe it to be sound, I
+	     do not (unless explicitly stated elsewhere) make any
+	     warranties or guarantees that it will achieve its stated
+	     purpose or function properly in any given situation.
+
+A Reviewed-by tag is a statement of opinion that the patch is an
+appropriate modification of the kernel without any remaining serious
+technical issues.  Any interested reviewer (who has done the work) can
+offer a Reviewed-by tag for a patch.  This tag serves to give credit to
+reviewers and to inform maintainers of the degree of review which has been
+done on the patch.  Reviewed-by: tags, when supplied by reviewers known to
+understand the subject area and to perform thorough reviews, will normally
+increase the liklihood of your patch getting into the kernel.
+
+
+15) The canonical patch format
 
 The canonical patch subject line is:
 
