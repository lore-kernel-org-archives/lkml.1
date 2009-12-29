Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZL2EJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZL2EJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 23:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZL2EJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 23:09:25 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62713 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZL2EJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 23:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JL3xhDfngP86n6p86VP2n0yY8+at2b6MPRgTpl3aSk+sOGYL+GkeQNAaF9axi8tW14
         YofvzJ9kmdukwS+s8u/zNqn/UrXCdWa8WlilPUFuFETogqR+Mzd0x5exIum0b2JHXH52
         bvcF2tkKqQ6TV19hhzS5D7XEI4L+983dzG1Yc=
MIME-Version: 1.0
Date: Tue, 29 Dec 2009 10:09:24 +0600
Message-ID: <b9df5fa10912282009x5d0d2de4q36ab8a1f29d5a7de@mail.gmail.com>
Subject: [PATCH] input, mouse: Change the prototype of functions in lifebook.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When CONFIG_PM=n, then we are warned by the following warning:

drivers/input/mouse/lifebook.c:33: warning: 'lifebook_limit_serio3'
defined but not used
drivers/input/mouse/lifebook.c:41: warning: 'lifebook_set_6byte_proto'
defined but not used


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/input/mouse/lifebook.c	2009-12-28 12:37:51.000000000 +0600
+++ rakib/drivers/input/mouse/lifebook.c	2009-12-28 15:02:02.000000000 +0600
@@ -29,7 +29,7 @@ static bool lifebook_present;

 static const char *desired_serio_phys;

-static int lifebook_limit_serio3(const struct dmi_system_id *d)
+static inline int lifebook_limit_serio3(const struct dmi_system_id *d)
 {
 	desired_serio_phys = "isa0060/serio3";
 	return 0;
@@ -37,7 +37,7 @@ static int lifebook_limit_serio3(const s

 static bool lifebook_use_6byte_proto;

-static int lifebook_set_6byte_proto(const struct dmi_system_id *d)
+static inline int lifebook_set_6byte_proto(const struct dmi_system_id *d)
 {
 	lifebook_use_6byte_proto = true;
 	return 0;
