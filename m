Return-Path: <linux-kernel-owner+w=401wt.eu-S964847AbZJJCLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847AbZJJCLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 22:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934717AbZJJCLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 22:11:35 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:40573 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587AbZJJCLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 22:11:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=XiB2uJp9q9lfTXgSbZj5xRHmwvqwbjcx0yXiRd8N/luA0OsHZC/i0oA+XK9VG/EFqj
         Tahyns3soWDAxU53BUXUGeUjE/znBxNE7xxfRaKa5iYgZdT4eP4QJQ15CoNEPlvlLXyP
         VaHBDxbQMbje2fl5bAQ6YaHEveZrK+Qz3w1Xo=
MIME-Version: 1.0
Date: Sat, 10 Oct 2009 08:10:58 +0600
Message-ID: <b9df5fa10910091910u1b6bf14bg2781cb12c58b21f9@mail.gmail.com>
Subject: [PATCH] net,bonding: Add return statement in bond_create_proc_entry.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: bonding-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function bond_create_proc_entry supposed to return int instead of void.
And fixes the following compilation warning.

drivers/net/bonding/bond_main.c: In function `bond_create_proc_entry':
drivers/net/bonding/bond_main.c:3393: warning: control reaches end of
non-void function

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/drivers/net/bonding/bond_main.c	2009-10-09 17:38:35.000000000 +0600
+++ rakib/drivers/net/bonding/bond_main.c	2009-10-09 17:47:46.000000000 +0600
@@ -3391,6 +3391,7 @@ static void bond_destroy_proc_dir(void)

 static int bond_create_proc_entry(struct bonding *bond)
 {
+	return 0;
 }

 static void bond_remove_proc_entry(struct bonding *bond)
