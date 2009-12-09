Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZLISpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZLISpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbZLISpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:45:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1041 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbZLISpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:45:31 -0500
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] arch/x86: Add #define pr_fmt(fmt) and use pr_<level>
Date: Wed,  9 Dec 2009 10:45:32 -0800
Message-Id: <cover.1260383912.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <20091209072630.GA8187@elte.hu>
References: <20091209072630.GA8187@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the files that primarily use embedded prefixes:

Standardize a bit on use of pr_<level>, removed embedded prefixes
and use #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt as appropriate.
Coalesced long format strings.

Joe Perches (5):
  es7000_32.c: use pr_<level> and add pr_fmt(fmt)
  arch/x86/kernel/setup_percpu.c: use pr_<level> and add pr_fmt(fmt)
  i8254.c: Add pr_fmt(fmt)
  kmmio.c: Add and use pr_fmt(fmt)
  arch/x86/mm/mmio-mod.c: use pr_fmt

 arch/x86/kernel/apic/es7000_32.c |   12 ++++---
 arch/x86/kernel/setup_percpu.c   |   13 ++++---
 arch/x86/kvm/i8254.c             |   12 ++++---
 arch/x86/mm/kmmio.c              |   40 +++++++++++-----------
 arch/x86/mm/mmio-mod.c           |   71 ++++++++++++++++++-------------------
 5 files changed, 76 insertions(+), 72 deletions(-)
