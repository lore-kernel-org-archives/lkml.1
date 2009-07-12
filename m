Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZGLIMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZGLIMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 04:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZGLIL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 04:11:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:53895 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbZGLILz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 04:11:55 -0400
From: Cheng Renquan <crq@kernel.org>
To: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       crquan@gmail.com
Subject: [PATCH 0/6] kbuild configuration system improvements
Date: Sun, 12 Jul 2009 16:11:42 +0800
Message-Id: <1247386308-19628-1-git-send-email-crq@kernel.org>
X-Mailer: git-send-email 1.6.3.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Jul 2009 08:11:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

These patches improve usability of kernel configuration system,

1. add symbol's value shown accompanied in config item's help message;
2. move the real plumbing functions code from mconf.c to menu.c, make them
   be able to be shared with other configuration methods;
3. add "symbol's value shown" support for gconfig/xconfig/config;

    0001-add-symbol-value-to-help-find-the-real-depend.patch
    0002-add-menu_get_ext_help-function-to-display-more-infor.patch
    0003-menuconfig-improvements.patch
    0004-make-use-of-menu_get_ext_help-in-gconfig.patch
    0005-make-use-of-menu_get_ext_help-in-qconfig.patch
    0006-make-use-of-menu_get_ext_help-in-make-config.patch

--
Cheng Renquan
