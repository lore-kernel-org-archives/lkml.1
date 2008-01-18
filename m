Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYARKUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYARKUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYARKUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:20:30 -0500
Received: from free-electrons.com ([88.191.23.47]:56872 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYARKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:20:29 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: rob@landley.net
Subject: [PATCH] Documentation: mention email-clients.txt in SubmittingPatches
Date: Fri, 18 Jan 2008 11:20:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181120.03168.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to 2.6.24-rc8-git2

I was struggling to get my email-client no to mangle my patch files,
and I didn't find enough information in the SubmittingPatches file.
By looking for more information on the web, I eventually found the
email-clients.txt file, and it answered all my needs

This patch adds a reference to email-clients.txt in SubmittingPatches,
and Mozilla related information which is no longer accurate
(as opposed to the details found in email-clients.txt).

This should be helpful for people sending their first patches,
or not sending patches on a frequent basis.

Michael.

--
Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

diff -Naur linux-2.6.24-rc8-git2/Documentation/SubmittingPatches linux-2.6.24-rc8-git2-sp/Documentation/SubmittingPatches
--- linux-2.6.24-rc8-git2/Documentation/SubmittingPatches	2008-01-17 09:48:56.000000000 +0100
+++ linux-2.6.24-rc8-git2-sp/Documentation/SubmittingPatches	2008-01-18 10:29:46.000000000 +0100
@@ -220,20 +220,8 @@
 Exception:  If your mailer is mangling patches then someone may ask
 you to re-send them using MIME.
 
-
-WARNING: Some mailers like Mozilla send your messages with
----- message header ----
-Content-Type: text/plain; charset=us-ascii; format=flowed
----- message header ----
-The problem is that "format=flowed" makes some of the mailers
-on receiving side to replace TABs with spaces and do similar
-changes. Thus the patches from you can look corrupted.
-
-To fix this just make your mozilla defaults/pref/mailnews.js file to look like:
-pref("mailnews.send_plaintext_flowed", false); // RFC 2646=======
-pref("mailnews.display.disable_format_flowed_support", true);
-
-
+See Documentation/email-clients.txt for hints about configuring
+your e-mail client so that it sends your patches untouched.
 
 8) E-mail size.
 

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
