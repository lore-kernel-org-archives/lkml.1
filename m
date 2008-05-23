Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbYEWDSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbYEWDSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYEWDSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:18:20 -0400
Received: from ozlabs.org ([203.10.76.45]:53839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbYEWDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:18:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module, stopmachine and a doc addition
Date: Fri, 23 May 2008 13:18:01 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Matti Linnanvuori" <mattilinn@gmail.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Denis V. Lunev" <den@openvz.org>, Cyrill Gorcunov <gorcunov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231318.01233.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry this is misc crap, but these are the patches for 2.6.26 which weren't worth sending 
on their own).

The following changes since commit 78b58e549a3098a8c1408d0214bd25e5d5e7a3a3:
  Al Viro (1):
        HTC_EGPIO is ARM-only

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Christian Borntraeger (1):
      stop_machine: make stop_machine_run more virtualization friendly

Cyrill Gorcunov (1):
      module loading ELF handling: use SELFMAG instead of numeric constant

Denis V. Lunev (1):
      modules: proper cleanup of kobject without CONFIG_SYSFS

Matti Linnanvuori (1):
      doc: add a chapter about trylock functions [Bug 9011]

 Documentation/DocBook/kernel-locking.tmpl |   25 +++++++++++++++++++++++++
 kernel/module.c                           |   18 +++++++++++++++---
 kernel/stop_machine.c                     |    7 ++++---
 3 files changed, 44 insertions(+), 6 deletions(-)
