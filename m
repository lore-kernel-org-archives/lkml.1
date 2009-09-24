Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZIXPFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZIXPFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 11:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZIXPFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 11:05:14 -0400
Received: from ozlabs.org ([203.10.76.45]:36810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZIXPFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 11:05:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module and parameter updates
Date: Fri, 25 Sep 2009 00:35:11 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909250035.12395.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 94a8d5caba74211ec76dac80fc6e2d5c391530df:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Jan Beulich (2):
      module: reduce symbol table for loaded modules (v2)
      module: reduce string table for loaded modules (v2)

Johannes Berg (1):
      module: preferred way to use MODULE_AUTHOR

Peter Oberparleiter (1):
      param: allow whitespace as kernel parameter separator

Rusty Russell (2):
      module: fix memory leak when load fails after srcversion/version allocated
      module: don't call percpu_modfree on NULL pointer.

 include/linux/module.h |   17 ++++--
 kernel/module.c        |  159 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/params.c        |    7 +-
 3 files changed, 165 insertions(+), 18 deletions(-)
