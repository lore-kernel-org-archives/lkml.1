Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZBWPKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZBWPKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZBWPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:10:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:24359 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZBWPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a7LlNaVj/0iDLmNR5e1UAg0m3IcnRJsLwyyngeHDtS4xSSDSuxlAmOfln/PKaJ5SYk
         SnaFKU+cjsf3T+oTcQlleRbjNCimm5MoxW1Vc8eg/YE2lY4zkHoGXJe+6f+bFAJS9d7A
         4YaoyXDSh4P/ry6CgCri70mwElbQbj/k4kVHA=
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: [PATCH 0/6] [KBUILD] configuration system improvements
Date: Mon, 23 Feb 2009 23:09:58 +0800
Message-Id: <1235401804-8136-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This group of patches improve the usability of kernel configuration system,
mainly,

1. add symbol's value shown accompanied in config item's help message;
2. move the real plumbing functions code from mconf.c to menu.c, make them
   be able to be shared with other configuration methods;
3. add "symbol's value shown" support for gconfig/xconfig/config;

  0001--KBUILD-add-symbol-value-to-help-find-the-real-depe.patch
  0002--KBUILD-add-menu_get_ext_help-function-to-display-m.patch
  0003--KBUILD-menuconfig-improvements.patch
  0004--KBUILD-make-use-of-menu_get_ext_help-in-gconfig.patch
  0005--KBUILD-make-use-of-menu_get_ext_help-in-qconfig.patch
  0006--KBUILD-make-use-of-menu_get_ext_help-in-make-conf.patch

I found gconfig still lack of "search by symbol" support, and that would be
in another patch.

Request for comments, thanks.

--
Cheng Renquan, Shenzhen, China
