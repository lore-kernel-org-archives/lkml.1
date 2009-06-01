Return-Path: <linux-kernel-owner+w=401wt.eu-S1758980AbZFAO6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980AbZFAO6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbZFAO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:56:10 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35420 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188AbZFAOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cEkAUyvBDu1uXM9TmNtdCgYvuAnWttpzJTlq99xeXdoR1+HEkHdarpfgalGrRH21Cc
         53Uzj8lTrdN/kDg8RJt43puY2S810zHnmHWLdoY46YLCL1HWOzaWj2eNnFt/TOzqyiD+
         aJUw2gQxgx0i+gt9G9h6px4GPbZ3nR9PpePS4=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 08/10] tty_io: export tty_class
Date: Mon,  1 Jun 2009 18:54:49 +0400
Message-Id: <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-2-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com>
 <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently tty_class in a public variable in the tty_io.c
Export it to the modules to allow some usefull tricks.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 drivers/char/tty_io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 66b99a2..4b12d03 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2809,6 +2809,7 @@ int tty_put_char(struct tty_struct *tty, unsigned char ch)
 EXPORT_SYMBOL_GPL(tty_put_char);
 
 struct class *tty_class;
+EXPORT_SYMBOL(tty_class);
 
 /**
  *	tty_register_device - register a tty device
-- 
1.6.2.4

