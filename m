Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784Ab0AGOxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0AGOxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 09:53:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275Ab0AGOxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 09:53:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0AGOxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 09:53:11 -0500
From: Michal Marek <mmarek@suse.cz>
To: Nir Tzachar <nir.tzachar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] nconfig
Date: Thu,  7 Jan 2010 15:52:46 +0100
Message-Id: <1262875968-1078-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nir,

Just FYI: I queued nconfig for the next merge window. I added a patch to
mark some functions static and changed the description of your patch,
otherwise it's the v7 version you posted.

Michal Marek (1):
  nconfig: mark local functions as such

nir.tzachar@gmail.com (1):
  kconfig: new configuration interface (nconfig)

 scripts/kconfig/Makefile            |   16 +-
 scripts/kconfig/lkc.h               |    2 +-
 scripts/kconfig/lkc_proto.h         |    3 +-
 scripts/kconfig/mconf.c             |   13 -
 scripts/kconfig/menu.c              |   16 +-
 scripts/kconfig/nconf.c             | 1568 +++++++++++++++++++++++++++++++++++
 scripts/kconfig/nconf.gui.c         |  617 ++++++++++++++
 scripts/kconfig/nconf.h             |   95 +++
 scripts/kconfig/zconf.tab.c_shipped |    2 +-
 scripts/kconfig/zconf.y             |    2 +-
 10 files changed, 2314 insertions(+), 20 deletions(-)
 create mode 100644 scripts/kconfig/nconf.c
 create mode 100644 scripts/kconfig/nconf.gui.c
 create mode 100644 scripts/kconfig/nconf.h

