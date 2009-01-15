Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbZAOXEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbZAOXEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934440AbZAOW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:59:09 -0500
Received: from vena.lwn.net ([206.168.112.25]:47913 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934157AbZAOW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:59:07 -0500
Date: Thu, 15 Jan 2009 15:59:05 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Reported-by (Re: Fix a typo in the development process
 document.)
Message-ID: <20090115155905.36abc28e@bike.lwn.net>
In-Reply-To: <20090109151535.336c3afd.randy.dunlap@oracle.com>
References: <200901090059.n090xfIH030955@hera.kernel.org>
	<20090109151535.336c3afd.randy.dunlap@oracle.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 15:15:35 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> BTW, Jon, if Reported-by: is supposed to have a status that is
> (nearly) as well accepted as most of the other tags, then it should
> be documented in SubmittingPatches along with the other tags and not
> only in development-process/5.Posting, no?

Yes, it probably should.  How's the following?  I'll drop it into my
docs tree if nobody gripes.

jon

--

Document Reported-by: in SubmittingPatches

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index f309d3c..6f29e29 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -405,7 +405,14 @@ person it names.  This tag documents that potentially interested parties
 have been included in the discussion
 
 
-14) Using Tested-by: and Reviewed-by:
+14) Using Reported-by:, Tested-by: and Reviewed-by:
+
+If this patch fixes a problem reported by somebody else, consider adding a
+Reported-by: tag to credit the reporter for their contribution.  Please
+note that this tag should not be added without the reporter's permission,
+especially if the problem was not reported in a public forum.  That said,
+if we diligently credit our bug reporters, they will, hopefully, be
+inspired to help us again in the future.
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
