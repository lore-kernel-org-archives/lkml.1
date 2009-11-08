Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZKHUAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZKHUAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZKHUAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:00:44 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61575 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZKHUAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=nXo0LYS2JdKRqqo2CelZb/k0aOvALIMuqewV+Zbrb0pI93XGc62aBHILzp6GHqE7vz
         LjjRw0Q6fOq8OSvjjw2h0IdOnCobOUQJoYy0xICH7eV+KuP30Jo14L1N+TWJgz5FegUd
         r6LuepOMI7RaL1Ej3Q94BRFDLz5ow0+nHfQ6s=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?J=E9r=E9my_Cochoy?= <jeremy.cochoy@gmail.com>
Date: Sun, 8 Nov 2009 21:00:23 +0100
Message-ID: <a229bc400911081200r1f71e3c3m9952426b4d75ff8e@mail.gmail.com>
Subject: [Patch] ext2 comment
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just want to correct a mistake in comments, about ext2_find_entry.

--
diff -uNr a/fs/ext2/dir.c b/fs/ext2/dir.c
--- a/fs/ext2/dir.c     2009-11-08 20:20:06.000000000 +0100
+++ b/fs/ext2/dir.c     2009-11-04 19:16:58.000000000 +0100
@@ -353,8 +353,8 @@
  *     ext2_find_entry()
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
