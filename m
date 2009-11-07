Return-Path: <linux-kernel-owner+w=401wt.eu-S1751063AbZKGGpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063AbZKGGpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 01:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZKGGpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 01:45:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:44546 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750878AbZKGGpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 01:45:42 -0500
X-Authenticated: #154622
X-Provags-ID: V01U2FsdGVkX1/UJYgqwe/UKQfe8IYo5QqQf2u4m1ad3Ii0L3Nunh
	wmqbOs+/GLyqPl
From: Bernhard Kaindl <bernhard.kaindl@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Kaindl <bernhard.kaindl@gmx.net>, linux-kbuild@vger.kernel.org
Subject: [PATCH/RFC 0/4] user remarks for config symbols
Date: Sat,  7 Nov 2009 07:45:36 +0100
Message-Id: <cover.1256767265.git.aragorn@Anduril.ringwar.org>
X-Mailer: git-send-email 1.6.5.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                              - RFC -

--- Comments, Reviews, Test reports, Notes, everything welcome ---

Hi,

I recently had the need to create a documentation for a kernel config,
and decided to extend the kernel config tool(s) to allow me to do that
with minium effort.

Specifically, I extended make xconfig (and now also others) for editing
a remark per config symbol and I created a config2html frontend to the
kconfig lib which outputs the config options with their comments to a
HTML table.

Besides that, it was sometimes been interesting to be able to add a
note for some config choices in order to see that note again when
revisiting that config choice again later.

So I hope that the patches which I created could be useable by the
greater Linux community, and hereby, I submit them for discussion
and if liked, for inclusion.

Thanks,
Bernhard Kaindl

Bernhard Kaindl (4):
  Support loading and saving custom remarks for config symbols
  menuconfig: allow editing of remarks for config symbols
  xconfig: allow editing of remarks for config symbols
  make config / oldconfig: allow editing of remarks for config symbols

 scripts/kconfig/conf.c             |   19 +++++++++++++
 scripts/kconfig/confdata.c         |   45 ++++++++++++++++++++++++++++--
 scripts/kconfig/expr.h             |    1 +
 scripts/kconfig/lxdialog/menubox.c |    3 ++
 scripts/kconfig/mconf.c            |   51 ++++++++++++++++++++++++++++++++++
 scripts/kconfig/qconf.cc           |   53 ++++++++++++++++++++++++++++++++++++
 scripts/kconfig/qconf.h            |   19 +++++++++++++
 7 files changed, 188 insertions(+), 3 deletions(-)

PS: Here is also an update to my CREDITS entry:

Signed-off-by: Bernhard Kaindl <bernhard.kaindl@gmx.net>

diff --git a/CREDITS b/CREDITS
index 72b4878..a92c901 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1714,11 +1714,11 @@ S: Tata
 S: Hungary
 
 N: Bernhard Kaindl
-E: bkaindl@netway.at
-E: edv@bartelt.via.at
+E: bernhard.kaindl@gmx.net
 D: Author of a menu based configuration tool, kmenu, which 
 D: is the predecessor of 'make menuconfig' and 'make xconfig'.
-D: digiboard driver update(modularisation work and 2.1.x upd)
+D: Various fixes for the kernel configuration tools
+D: Digiboard driver update (modularisation work and 2.1.x update)
 S: Tallak 95
 S: 8103 Rein
 S: Austria
