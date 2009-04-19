Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbZDSNlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbZDSNlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759617AbZDSNlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:22 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:38993 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbZDSNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:21 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 00/10] kconfig: various fixes and documentation updates
Date: Sun, 19 Apr 2009 15:41:17 +0200
Message-Id: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
X-Provags-ID: V01U2FsdGVkX1/YrsYKDoqllODAop4/Nm2YMXFXjHBnDnucglO+
	cGuH1y2qmJtmF6QoCVuGEl6Z4vSF88DdDauXmKqEa1ejTHjT0E
	NwUdOY2EA2JpqSpqkLsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches  1-3: documentation updates, typo fixes
Patch      4: .gitignore
Patches  5-8: qconf fixes (compiler warnings/errors)
Patches 9-10: environment variable fixes (KCONFIG_CONFIG + KCONFIG_AUTOCONFIG)

Markus Heidelberg (10):
  kconfig: fix typo "mconfig" to "menuconfig" in a comment
  kconfig: add a note about the deps to the 'silentoldconfig' help
  kconfig: resort the documentation of the environment variables
  gitignore: ignore Kconfig i18n files
  kconfig qconf: fix -Wall compiler warnings
  kconfig qconf: fix namespace for Horizontal and Vertical enum values
  kconfig qconf: add namespace for use of Key_ enum values
  kconfig qconf: fix the type of the desktop widget
  kconfig: do not hardcode ".config" filename
  kconfig: do not hardcode "include/config/auto.conf" filename

 Documentation/kbuild/kconfig.txt |  116 +++++++++++++++++++------------------
 README                           |    1 +
 scripts/kconfig/.gitignore       |    2 +
 scripts/kconfig/Makefile         |    4 +-
 scripts/kconfig/conf.c           |    7 +-
 scripts/kconfig/confdata.c       |   20 ++++---
 scripts/kconfig/lkc.h            |    1 +
 scripts/kconfig/qconf.cc         |   48 +++++++++-------
 scripts/kconfig/util.c           |    6 +-
 9 files changed, 112 insertions(+), 93 deletions(-)

