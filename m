Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbYA2GQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbYA2GQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 01:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYA2GQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 01:16:16 -0500
Received: from ozlabs.org ([203.10.76.45]:39576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYA2GQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 01:16:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module patches
Date: Tue, 29 Jan 2008 17:16:12 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jon Masters <jonathan@jonmasters.org>, Denis Cheng <crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291716.13149.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8561b089afbaed2651591e5a4574fdca451d82f2:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus master

Denis Cheng (1):
      module: fix the module name length in param_sysfs_builtin

Greg Kroah-Hartman (1):
      Module: check to see if we have a built in module with the same name

Jon Masters (1):
      module: add module taint on ndiswrapper

Rusty Russell (5):
      module: Don't report discarded init pages as kernel text.
      module: wait for dependent modules doing init.
      module: Fix gratuitous sprintf in module.c
      module: better OOPS and lockdep coverage for loading modules
      module: make module_address_lookup safe

 include/linux/module.h |   22 ++++++----
 kernel/extable.c       |    3 +-
 kernel/kallsyms.c      |   11 ++---
 kernel/module.c        |  102 ++++++++++++++++++++++++++++++++----------------
 kernel/params.c        |    8 +--
 5 files changed, 90 insertions(+), 56 deletions(-)
