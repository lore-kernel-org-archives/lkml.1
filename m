Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbZK2XbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbZK2XbM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZK2XbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:31:11 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:49005 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZK2XbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Oc60tl0oHRf1LE/Dqw6arTBH0ldeX/ZXlvGWDc0pcQYwihXl9qOQAFYYjAYe3mqM9o
         P5VGuwkHXf76chF9hPaCRZvOmkSDNnuOP6GmRlQTkz6jaG7gFIdEzjRIQIPTZ9o96ynv
         SjqEz6ujaM8z5C0FQdDvj7rVomf7X7/gX7kIc=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?J=E9r=E9my_Cochoy?= <jeremy.cochoy@gmail.com>
Date: Mon, 30 Nov 2009 00:30:55 +0100
Message-ID: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
Subject: [PATCH] fs/ext2: ext2_readdir comment about returns
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
       ronny.pretzsch@dfs.de, Corentin Chary <corentin.chary@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Jeremy Cochoy <jeremy.cochoy@gmail.com>

Hello,

I submit a short correction about a comment in ext2/dir.c

(I've already send it but it wasn't the good patch format and i didn't
cc the right people.)

PS: Please excuse me if I make mistakes with the netiquette, it's my
first patch and i wich to send more useful patchs next time, without
hurting your eyes.

Best regards,

-----
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6cde970..fc2bd05 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -353,8 +353,8 @@ ext2_readdir (struct file * filp, void * dirent,
filldir_t filldir)
 * ext2_find_entry()
 *
 * finds an entry in the specified directory with the wanted name. It
- * returns the page in which the entry was found, and the entry itself
- * (as a parameter - res_dir). Page is returned mapped and unlocked.
+ * returns the page in which the entry was found (as a parameter - res_page),
+ * and the entry itself. Page is returned mapped and unlocked.
 * Entry is guaranteed to be valid.
 */
struct ext2_dir_entry_2 *ext2_find_entry (struct inode * dir,

--
Jérémy Cochoy - L1 MI (Lyon1)
Mail : jeremy.cochoy@gmail.com
Tel : 06-43-01-74-02
Alias Zenol - http://zenol.fr
