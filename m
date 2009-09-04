Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbZIDOvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbZIDOvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbZIDOvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:51:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933637AbZIDOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:51:40 -0400
From: Michal Marek <mmarek@suse.cz>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 0/2] kbuild: generate modules.builtin
Date: Fri,  4 Sep 2009 16:51:31 +0200
Message-Id: <cover.1252075736.git.mmarek@suse.cz>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, with a small fix from Jan. As Sam has been busy with other things
lately, would it be possible to add this to -mm so that we can start adding
support for this to module-init-tools?

Thanks,
Michal

Jan Beulich (1):
  kbuild: rebuild fix for Makefile.modbuiltin

Michal Marek (1):
  kbuild: generate modules.builtin

 .gitignore                  |    1 +
 Makefile                    |   14 ++++++++---
 scripts/Kbuild.include      |    6 +++++
 scripts/Makefile.lib        |    5 +++-
 scripts/Makefile.modbuiltin |   52 +++++++++++++++++++++++++++++++++++++++++++
 scripts/kconfig/confdata.c  |   48 +++++++++++++++++++++++++++++++++-----
 6 files changed, 114 insertions(+), 12 deletions(-)
 create mode 100644 scripts/Makefile.modbuiltin

