Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYEALSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYEALSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 07:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbYEALSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 07:18:42 -0400
Received: from ozlabs.org ([203.10.76.45]:36949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbYEALSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 07:18:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] module patches for 2.6.26
Date: Thu, 1 May 2008 21:18:28 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       "Jan Beulich" <jbeulich@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805012118.29294.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e4c576b911e364737b1bf4f5bfdab1c440713f26:
  Theodore Ts'o (1):
        Update .gitignore to include include/linux/bounds.h

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Peter Oberparleiter (1):
      module: add MODULE_STATE_GOING notifier call

Rusty Russell (5):
      module: make module_sect_attrs private to kernel/module.c
      module: reduce module image and resident size
      module: neaten __find_symbol, rename to find_symbol
      module: set unused_gpl_crcs instead of overwriting unused_crcs
      module: Enhance verify_export_symbols

 include/linux/module.h |   19 +---
 kernel/module.c        |  319 ++++++++++++++++++++++++++----------------------
 2 files changed, 172 insertions(+), 166 deletions(-)
