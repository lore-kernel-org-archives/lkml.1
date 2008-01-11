Return-Path: <linux-kernel-owner+w=401wt.eu-S1763035AbYAKWx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035AbYAKWx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 17:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761500AbYAKWwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 17:52:50 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57850 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760101AbYAKWws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 17:52:48 -0500
Subject: [PATCH 6/10] kconfig: gconfig: symbol fix
From: EGRY Gabor <gaboregry1@t-online.hu>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Content-Type: text/plain
Date: Fri, 11 Jan 2008 23:49:12 +0100
Message-Id: <1200091752.10603.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gettext support for symbol names are unnecessary.

Signed-off-by: Egry Gabor <gaboregry1@t-online.hu>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
---

 kbuild-szilard/scripts/kconfig/gconf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/gconf.c~kconfig-i18n-11-gconfig-symbol-fix scripts/kconfig/gconf.c
--- kbuild/scripts/kconfig/gconf.c~kconfig-i18n-11-gconfig-symbol-fix	2008-01-11 22:27:14.000000000 +0100
+++ kbuild-szilard/scripts/kconfig/gconf.c	2008-01-11 22:27:14.000000000 +0100
@@ -466,7 +466,7 @@ static void text_insert_help(struct menu
 		help = _(help);
 
 	if (menu->sym && menu->sym->name)
-		name = g_strdup_printf(_(menu->sym->name));
+		name = g_strdup_printf(menu->sym->name);
 	else
 		name = g_strdup("");
 
_

