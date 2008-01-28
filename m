Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYA1I5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYA1I5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbYA1I5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:57:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758933AbYA1I5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rPZaMpns+ztg3HAhIonm7SHHJtyuhOdMlxt+d2IAnKds0yE4vgdgCSDGRRmqrjz1scr9FYSd18AABU/Pngy0T0dkGULbCacR6VE6EGEmwf5Pu//OePpXpXIeuNKPnEnzg2qoiOYWdvDVXhgEj4hEUoyOquP/qUnBeh6smg6ULWE=
Date: Mon, 28 Jan 2008 16:58:00 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kobject : kerneldoc comment fix
Message-ID: <20080128085800.GB27570@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kerneldoc comment of kobject_create.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
lib/kobject.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr a/lib/kobject.c b/lib/kobject.c
--- a/lib/kobject.c	2008-01-28 16:53:08.000000000 +0800
+++ b/lib/kobject.c	2008-01-28 16:53:08.000000000 +0800
@@ -637,7 +637,7 @@ struct kobject *kobject_create(void)
  * @name: the name for the kset
  * @parent: the parent kobject of this kobject, if any.
  *
- * This function creates a kset structure dynamically and registers it
+ * This function creates a kobject structure dynamically and registers it
  * with sysfs.  When you are finished with this structure, call
  * kobject_put() and the structure will be dynamically freed when
  * it is no longer being used.
