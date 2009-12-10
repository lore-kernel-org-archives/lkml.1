Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbZLJO5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbZLJO5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760830AbZLJO5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:57:46 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36925 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbZLJO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:57:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oG37as8fHw62rAx5rGckRAezdZ+yVE+dmcg6Oj+1/QO5okUS27dU306CBqdzhjDNkQ
         4mQnFD24Z+/zQ7fyjmz3po3Zh4H22y4oYkm6+A6jU0bcbn+puIH/5gSLWYSQzbacIAoV
         /uZtCHLjdljdsLAszUv+nFV+zkQGZtGavzx0o=
Message-ID: <4B210C6C.3060103@tuffmail.co.uk>
Date: Thu, 10 Dec 2009 14:57:48 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: [PATCH] Documentation/email-clients.txt: clarify Thunderbird section
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Make it clearer that there are three different methods here,
   by using two different levels of indentation.

2) Reorder the different methods:

  - Disabling word wrap altogether should be the last option.
    It involves manually editing config files, and many Thunderbird
    users will not want to disable word wrap for normal (non-patch)
    messages.

  - "Preformat mode" should be the first option. It's really convenient.
    (Guess how I sent this patch).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 Documentation/email-clients.txt |   56 +++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index a618efa..c899444 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -180,34 +180,40 @@ Sylpheed (GUI)
 Thunderbird (GUI)
 
 By default, thunderbird likes to mangle text, but there are ways to
-coerce it into being nice.
-
-- Under account settings, composition and addressing, uncheck "Compose
-  messages in HTML format".
-
-- Edit your Thunderbird config settings to tell it not to wrap lines:
-      user_pref("mailnews.wraplength", 0);
-
-- Edit your Thunderbird config settings so that it won't use format=flowed:
-      user_pref("mailnews.send_plaintext_flowed", false);
-
-- You need to get Thunderbird into preformat mode:
-. If you compose HTML messages by default, it's not too hard. Just select
-  "Preformat" from the drop-down box just under the subject line.
-. If you compose in text by default, you have to tell it to compose a new
-  message in HTML (just as a one-off), and then force it from there back to
-  text, else it will wrap lines. To do this, use shift-click on the Write
-  icon to compose to get HTML compose mode, then select "Preformat" from
-  the drop-down box just under the subject line.
-
-- Allows use of an external editor:
-  The easiest thing to do with Thunderbird and patches is to use an
-  "external editor" extension and then just use your favorite $EDITOR
-  for reading/merging patches into the body text.  To do this, download
-  and install the extension, then add a button for it using
+coerce it into being nice.  Try one of the methods below.
+
+- Get Thunderbird into preformat mode:
+
+  - If you compose HTML messages by default, select "Preformat" from the
+    drop-down box just under the subject line.
+
+  - If you compose in text by default, you have to tell it to compose a new
+    message in HTML (just as a one-off), and then force it from there back to
+    text, else it will wrap lines. To do this, use shift-click on the Write
+    icon to compose to get HTML compose mode, then select "Preformat" from
+    the drop-down box just under the subject line.
+
+- Use an external editor:
+
+  You can install an "external editor" extension which will allow you to use
+  your favorite $EDITOR for reading/merging patches into the body text.
+  First download and install the extension, then add a button for it using
   View->Toolbars->Customize... and finally just click on it when in the
   Compose dialog.
 
+- Disable word wrap completely:
+
+  1. Under account settings, composition and addressing, uncheck "Compose
+     messages in HTML format".
+
+  2. Edit your Thunderbird config settings to tell it not to wrap lines:
+
+             user_pref("mailnews.wraplength", 0);
+
+  3. Edit your Thunderbird config settings so it won't use format=flowed:
+
+             user_pref("mailnews.send_plaintext_flowed", false);
+
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 TkRat (GUI)
 
-- 
1.6.3.3



