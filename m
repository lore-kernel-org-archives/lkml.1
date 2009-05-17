Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZEQXhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZEQXhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZEQXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:48 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:43778 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZEQXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:47 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 00/10] kconfig: various fixes and documentation updates
Date: Mon, 18 May 2009 01:36:44 +0200
Message-Id: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
X-Provags-ID: V01U2FsdGVkX1/MhsewowDRMMoSwJXRoMvzuTS7YzO7WK50VhJ7
	/UhwAhwHljqjScQHq5PtEubBqTuWXUnx+5h5gtWOTlV1fT0eBb
	LLI4omJ3c7359qmQ0IxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I sent this series about 4 weeks ago on 2009-04-19, but didn't receive any
comments. Is Roman inactive currently?


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

