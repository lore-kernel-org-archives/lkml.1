Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbXHXT2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbXHXT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXHXT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:28:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1325 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbXHXT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:28:40 -0400
Subject: [PATCH] MAINTAINERS and scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Cc: Al Viro <viro@ftp.linux.org.uk>, Rene Herman <rene.herman@gmail.com>,
       Junio C Hamano <gitster@pobox.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 12:28:37 -0700
Message-Id: <1187983717.32738.141.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

git pull git://repo.or.cz/linux-2.6/trivial-mods.git get_maintainer

Added the capability to more easily find the appropriate parties to CC
for a patch.

Uses the most frequent patch "-by:" lines in git if available and also
uses MAINTAINER subsystem information.

Added "F:" and "X:" file patterns to subsystems in MAINTAINERS
Added scripts/get_maintainer.pl to automate CC retrieval.

Usage:  perl scripts/get_maintainer.pl <patchfile>
Usage:  perl scripts/get_maintainer.pl -f <file>

Coupled with git-send-email modifications,
this patch helps to automate patch CC'ing

Signed-off-by: Joe Perches <joe@perches.com>

Bits and pieces Signed-off-by: and Acked-by: (probably missed a few)

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Nathan Laredo <laredo@gnu.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mike Isely <isely@pobox.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: GOTO Masanori <gotom@sanori.org>
Acked-by: Linas Vepstas <linas@austin.ibm.com>
Acked-by: Ron Mercer <ron.mercer@qlogic.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Len Brown <len.brown@intel.com>
Acked-by: Josh Triplett <josh@freedesktop.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Acked-by: Chris Snook <csnook@redhat.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Acked-by: Dave Dillow <dave@thedillows.org>
Acked-by: Kent Yoder <shpedoikal@gmail.com>
Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Salyzyn, Mark <mark_salyzyn@adaptec.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Acked-by: Dave Kleikamp <shaggy@vnet.linux.ibm.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Acked-By: Thomas Sailer <t.sailer@alumni.ethz.ch>
Acked-by: Alan Cox <alan@redhat.com>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
Acked-by: Mitchell Blank Jr <mitch@sfgoth.com>

MAINTAINERS               | 1316 ++++++++++++++++++++++++++++++++++++++++-----
scripts/get_maintainer.pl |  466 ++++++++++++++++


