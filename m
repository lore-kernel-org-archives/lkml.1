Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbXIKRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbXIKRRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXIKRRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:17:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18728 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXIKRRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:17:09 -0400
Date: Tue, 11 Sep 2007 10:16:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jgarzik <jgarzik@pobox.com>
Subject: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-Id: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Requested by Jeff Garzik.

Add info about various email clients and their applicability
in being used to send Linux kernel patches.

Some notes takes from http://mbligh.org/linuxdocs/Email/Clients
Portions used with permission.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/email-clients.txt |  158 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

--- /dev/null
+++ linux-2.6.23-rc5-git1/Documentation/email-clients.txt
@@ -0,0 +1,158 @@
+Email clients info for Linux
+======================================================================
+
+General Preferences
+----------------------------------------------------------------------
+Patches for the Linux kernel are submitted via email, preferably as
+inline text in the body of the email.  Some maintainers accept
+attachments, but then the attachments should have content-type
+"text/plain".  However, attachments are generally frowned upon because
+it makes quoting portions of the patch more difficult in the patch
+review process.
+
+Email clients that are used for Linux kernel patches should send the
+patch text untouched.  For example, they should not modify or delete tabs
+or spaces, even at the beginning or end of lines.
+
+<question about character set encoding/code pages:>
+They also should not modify the character set encoding of the text.
+
+Email clients should generate and maintain References: or In-Reply-To:
+headers so that mail threading is not broken.
+
+Copy-and-paste (or cut-and-paste) usually does not work for patches
+because tabs are converted to spaces.  I have seen comments that
+xclipboard, xclip, and/or xcutsel do work, but I cannot confirm this.
+
+Don't use PGP/GPG signatures in mail that contains patches.
+This breaks many scripts that read and apply the patches.
+(This should be fixable. ??)
+
+
+Some email client (MUA) hints
+----------------------------------------------------------------------
+Legend:
+TUI = text-based user interface
+GUI = graphical user interface
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Alpine (TUI)
+
+<I don't know.  Maybe Adrian or Linus can comment.>
+
+Are any special config options needed?
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Evolutions (GUI)
+
+Some people seem to use this successfully for patches.
+
+What config options are needed?
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Kmail (GUI)
+
+Some people use Kmail successfully for patches.
+
+The default setting of not composing in HTML is appropriate; do not
+enable it.
+
+When composing an email, under options, uncheck "word wrap". The only
+disadvantage is any text you type in the email will not be word-wrapped
+so you will have to manually word wrap text before the patch. The easiest
+way around this is to compose your email with word wrap enabled, then save
+it as a draft. Once you pull it up again from your drafts it is now hard
+word-wrapped and you can uncheck "word wrap" without losing the existing
+wrapping.
+
+At the bottom of your email, put the commonly-used patch delimiter before
+inserting your patch:  three hyphens (---).
+
+Then from the "Message" menu item, select insert file and choose your patch.
+As an added bonus I recommend customising the message creation toolbar menu
+and putting the "insert file" icon there.
+
+You can safely GPG sign attachments, but inlined text is preferred for
+patches so do not GPG sign them.  Signing patches that have been inserted
+as inlined text will make them tricky to extract from their 7-bit encoding.
+
+If you absolutely must send patches as attachments instead of inlining
+them as text, right click on the attachment and select properties, and
+highlight "Suggest automatic display" to make the attachment inlined to
+make it more viewable.
+
+When saving patches that are sent as inlined text, select the email that
+contains the patch from the message list pane, right click and select
+"save as".  You can use the whole email unmodified as a patch if it was
+properly composed.  There is no option currently to save the email when
+you are actually viewing it in its own window - I've filed a request at
+kmail's bugzilla and hopefully this will be addressed.  Emails are saved
+as read-write for user only so you will have to chmod them to make them
+group and world readable if you copy them elsewhere.
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Lotus Notes (GUI)
+
+Run away from it.
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Mutt (TUI)
+
+Plenty of Linux developers use mutt, so it must work pretty well.
+
+Are there any special config options that are needed??
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Pine (TUI)
+
+Pine has had some whitespace truncation issues.  There have also been
+patches for this problem.  I don't know the current status.  Is there
+a config option for this?
+
+Are there any special config options that are needed??
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Sylpheed (GUI)
+
+- Works well for inlining text (or using attachments).
+- Allows use of an external editor.
+- Not good for IMAP.
+- Is slow on large folders.
+- Won't do TLS SMTP auth over a non-SSL connection.
+- Has a helpful ruler bar in the compose window.
+- Adding addresses to address book doesn't understand the display name
+  properly.
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Thunderbird (GUI)
+
+By default, thunderbird likes to mangle text, but there are ways to
+coerce it into being nice.
+
+- Under account settings, composition and addressing, uncheck "Compose
+  messages in HTML format".
+
+- Edit your Thunderbird config settings to tell it not to wrap lines:
+      user_pref("mailnews.wraplength", 0);
+
+- Edit your Thunderbird config settings so that it won't use format=flowed:
+      user_pref("mailnews.send_plaintext_flowed", false);
+
+- You need to get Thunderbird into preformat mode:
+. If you compose HTML messages by default, it's not too hard. Just select
+  "Preformat" from the drop-down box just under the subject line.
+. If you compose in text by default, you have to tell it to compose a new
+  message in HTML (just as a one-off), and then force it from there back to
+  text, else it will wrap lines. To do this, use shift-click on the Write
+  icon to compose to get HTML compose mode, then select "Preformat" from
+  the drop-down box just under the subject line.
+
+- Allows use of an external editor:
+  The easiest thing to do with Thunderbird and patches is to use an
+  "external editor" extension and then just use your favorite $EDITOR
+  for reading/merging patches into the body text.  To do this, download
+  and install the extension, then add a button for it using
+  View->Toolbars->Customize... and finally just click on it when in the
+  Compose dialog.
+
+                                ###
