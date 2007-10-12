Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXJLXDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXJLXDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760928AbXJLWXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:23:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760870AbXJLWXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:23:12 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 71/75] Driver core: rename ktype_edd and ktype_efivar
Date: Fri, 12 Oct 2007 15:17:15 -0700
Message-Id: <1192227776447-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922277711448-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
 <11922277041450-git-send-email-gregkh@suse.de>
 <11922277091389-git-send-email-gregkh@suse.de>
 <11922277133374-git-send-email-gregkh@suse.de>
 <11922277181565-git-send-email-gregkh@suse.de>
 <11922277222714-git-send-email-gregkh@suse.de>
 <11922277261501-git-send-email-gregkh@suse.de>
 <1192227731677-git-send-email-gregkh@suse.de>
 <11922277364080-git-send-email-gregkh@suse.de>
 <11922277403355-git-send-email-gregkh@suse.de>
 <11922277441791-git-send-email-gregkh@suse.de>
 <11922277493627-git-send-email-gregkh@suse.de>
 <11922277571933-git-send-email-gregkh@suse.de>
 <119222776277-git-send-email-gregkh@suse.de>
 <11922277663827-git-send-email-gregkh@suse.de>
 <11922277711448-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it a bit more sane when trying to figure out how to clean up
the ktype mess.

Based on a larger patch from Kay Sievers

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/edd.c     |    4 ++--
 drivers/firmware/efivars.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 0fb730e..6942e06 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -625,13 +625,13 @@ static void edd_release(struct kobject * kobj)
 	kfree(dev);
 }
 
-static struct kobj_type ktype_edd = {
+static struct kobj_type edd_ktype = {
 	.release	= edd_release,
 	.sysfs_ops	= &edd_attr_ops,
 	.default_attrs	= def_attrs,
 };
 
-static decl_subsys(edd,&ktype_edd,NULL);
+static decl_subsys(edd, &edd_ktype, NULL);
 
 
 /**
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index bfd2d67..858a7b9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -402,7 +402,7 @@ static struct attribute *def_attrs[] = {
 	NULL,
 };
 
-static struct kobj_type ktype_efivar = {
+static struct kobj_type efivar_ktype = {
 	.release = efivar_release,
 	.sysfs_ops = &efivar_attr_ops,
 	.default_attrs = def_attrs,
@@ -583,7 +583,7 @@ static struct subsys_attribute *efi_subsys_attrs[] = {
 	NULL,	/* maybe more in the future? */
 };
 
-static decl_subsys(vars, &ktype_efivar, NULL);
+static decl_subsys(vars, &efivar_ktype, NULL);
 static decl_subsys(efi, NULL, NULL);
 
 /*
-- 
1.5.3.4

