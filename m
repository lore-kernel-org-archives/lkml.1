Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYKEVOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYKEVOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYKEVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:14:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbYKEVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:14:43 -0500
Date: Wed, 5 Nov 2008 13:14:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SAM9 watchdog - supported on all SAM9 and CAP9
 processors
Message-Id: <20081105131429.536748d2.akpm@linux-foundation.org>
In-Reply-To: <cd73a99e0811051258v7c5c8bd8qf82f4e5a81068c85@mail.gmail.com>
References: <cd73a99e0811051236x3c852ce7w5d16a695d8efb9c6@mail.gmail.com>
	<20081105124543.7679a313.akpm@linux-foundation.org>
	<cd73a99e0811051258v7c5c8bd8qf82f4e5a81068c85@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 22:58:45 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> > sylpheed mucks that up.  text/plain attachments would be preferred,
> > please.  Inlined non-wordwrapped, non-tab-replaced, non-space-stuffed
> > text would of course be even better.
> 
> Unfortunately, gmail seems to mess up (ie, corrupt the whitespace of)
> the inlined patches.

trust me, I noticed ;)


I have this queued:

From: Tim Hockin <thockin@google.com>

Signed-off-by: Tim Hockin <thockin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN Documentation/email-clients.txt~documentation-email-clientstxt-add-some-info-about-gmail Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~documentation-email-clientstxt-add-some-info-about-gmail
+++ a/Documentation/email-clients.txt
@@ -213,4 +213,29 @@ TkRat (GUI)
 
 Works.  Use "Insert file..." or external editor.
 
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Gmail (Web GUI)
+
+If you just have to use Gmail to send patches, it CAN be made to work.  It
+requires a bit of external help, though.
+
+The first problem is that Gmail converts tabs to spaces.  This will
+totally break your patches.  To prevent this, you have to use a different
+editor.  There is a firefox extension called "ViewSourceWith"
+(https://addons.mozilla.org/en-US/firefox/addon/394) which allows you to
+edit any text box in the editor of your choice.  Configure it to launch
+your favorite editor.  When you want to send a patch, use this technique.
+Once you have crafted your messsage + patch, save and exit the editor,
+which should reload the Gmail edit box.  GMAIL WILL PRESERVE THE TABS.
+Hoorah.  Apparently you can cut-n-paste literal tabs, but Gmail will
+convert those to spaces upon sending!
+
+The second problem is that Gmail converts tabs to spaces on replies.  If
+you reply to a patch, don't expect to be able to apply it as a patch.
+
+The last problem is that Gmail will base64-encode any message that has a
+non-ASCII character.  That includes things like European names.  Be aware.
+
+Gmail is not convenient for lkml patches, but CAN be made to work.
+
                                 ###
_

