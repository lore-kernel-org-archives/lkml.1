Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZKRKMC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZKRKMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:12:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZKRKMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:12:01 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:46179 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbZKRKMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:12:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=iXla65zWe0ZngV3/t2v8w64nWuVVUnIROI5djRS8MonnEWzB9WzG3CfkViyTB0sgfx
         dbVptqYaNvdI98To3ZI70HyjYW9Z3Jbyh6lLhL6Pj92WAk3okDt68Htt5zWZdP6z7Xi5
         yRklbRWIzZhZW9X86CDJ4YC8VH793VQ0clnto=
MIME-Version: 1.0
Date: Wed, 18 Nov 2009 16:12:06 +0600
Message-ID: <b9df5fa10911180212h5d74e640g859e7cebe952689@mail.gmail.com>
Subject: [PATCH] kconfig: Add missing prototype
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Patch named 'kbuild-generate-modulesbuiltin.patch' introduce a new
function 'fprintf2', without previous prototype declared. This patch adds
this missing prototype.

 When building defconfig on i386 - we were hit by the following warning:

  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:2451:
scripts/kconfig/confdata.c:676: warning: no previous prototype for 'fprintf2'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/scripts/kconfig/lkc.h	2009-11-18 16:37:46.000000000 +0600
+++ rakib/scripts/kconfig/lkc.h	2009-11-18 17:03:19.000000000 +0600
@@ -79,6 +79,7 @@ char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 void conf_set_all_new_symbols(enum conf_def_mode mode);
+int fprintf2(FILE *f1, FILE *f2, const char *fmt, ...);

 /* kconfig_load.c */
 void kconfig_load(void);
