Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbYL2Nmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbYL2Nmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYL2Nm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:42:29 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33528 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbYL2Nm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:42:28 -0500
Date: Mon, 29 Dec 2008 14:44:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: pending kbuild updates
Message-ID: <20081229134402.GA7069@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is the next batch queued up for merging.
Highlights:

o improved userspace header checks (spawns a lot of warnings now!)
o some kconfig improvements for check of recursive dependencies
o drop retrun of void warning from sparse

	Sam

Hannes Eder (1):
      kbuild: disable sparse warning "returning void-valued expression"

Mike Frysinger (2):
      headers_check.pl: disallow extern's
      kbuild: in headers_install autoconvert asm/inline/volatile to __xxx__

Randy Dunlap (1):
      kbuild: make *config usage docs

Sam Ravnborg (9):
      m68k: fix recursive dependency in Kconfig
      kconfig: explain symbol value defaults
      kconfig: add comments to symbol flags
      kconfig: struct property commented
      kconfig: improve readout when we hit recursive dependencies
      kconfig: print all locations when we see a recursive dependency
      kconfig: improve error messages for bad source statements
      kbuild: check for leaked CONFIG_ symbols to userspace
      kbuild: document environment variables

 Documentation/kbuild/00-INDEX       |    6 +-
 Documentation/kbuild/kbuild.txt     |  126 +++++++++++++++++++++++
 Documentation/kbuild/kconfig.txt    |  188 +++++++++++++++++++++++++++++++++++
 Makefile                            |    3 +-
 README                              |   32 ++++---
 arch/m68k/Kconfig                   |    1 -
 scripts/headers_check.pl            |   21 ++++-
 scripts/headers_install.pl          |    3 +
 scripts/kconfig/expr.h              |   83 ++++++++++-----
 scripts/kconfig/lex.zconf.c_shipped |    7 +-
 scripts/kconfig/menu.c              |    2 +
 scripts/kconfig/symbol.c            |   27 ++++-
 scripts/kconfig/zconf.l             |    7 +-
 13 files changed, 453 insertions(+), 53 deletions(-)
