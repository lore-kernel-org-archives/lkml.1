Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0BVOTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:19:17 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40671 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0BVOTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZeWfcLQxoIqscCu4xuOaZ8MzXUpn7UDTTGLbLYt5sqKV6Rq4PUXcbj2n9Vgkbdi1zX
         D9D+UjJ9wuMTthG5QxAq63WUbCh089qYIgRHA8L03xOgRE0Di1rYJATZpVdIEdkicvfL
         LIpzXWE9vhDM3W+aomy+Kh+ABa7eJKggqnlTM=
Date: Mon, 22 Feb 2010 22:19:07 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/06] update email client doc about gmail
Message-ID: <20100222141907.GA9028@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gmail web gui does not work for sending patches now even with firefox
"view source with" extension. It will use windows style line breaks
to wrap lines automatically when sening email.

Rewrite the gmail web gui part of email client documentation.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 Documentation/email-clients.txt |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- linux-2.6.orig/Documentation/email-clients.txt	2010-02-16 17:11:38.000000000 +0800
+++ linux-2.6/Documentation/email-clients.txt	2010-02-16 17:23:32.000000000 +0800
@@ -216,26 +216,14 @@ Works.  Use "Insert file..." or external
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Gmail (Web GUI)
 
-If you just have to use Gmail to send patches, it CAN be made to work.  It
-requires a bit of external help, though.
+Does not work for sending patches.
 
-The first problem is that Gmail converts tabs to spaces.  This will
-totally break your patches.  To prevent this, you have to use a different
-editor.  There is a firefox extension called "ViewSourceWith"
-(https://addons.mozilla.org/en-US/firefox/addon/394) which allows you to
-edit any text box in the editor of your choice.  Configure it to launch
-your favorite editor.  When you want to send a patch, use this technique.
-Once you have crafted your messsage + patch, save and exit the editor,
-which should reload the Gmail edit box.  GMAIL WILL PRESERVE THE TABS.
-Hoorah.  Apparently you can cut-n-paste literal tabs, but Gmail will
-convert those to spaces upon sending!
+Gmail web client converts tabs to spaces automatically.
 
-The second problem is that Gmail converts tabs to spaces on replies.  If
-you reply to a patch, don't expect to be able to apply it as a patch.
+At the same time it wraps lines every 78 chars with CRLF style line breaks
+although tab2space problem can be solved with external editor.
 
-The last problem is that Gmail will base64-encode any message that has a
-non-ASCII character.  That includes things like European names.  Be aware.
-
-Gmail is not convenient for lkml patches, but CAN be made to work.
+Another problem is that Gmail will base64-encode any message that has a
+non-ASCII character. That includes things like European names.
 
                                 ###
