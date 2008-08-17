Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYHQTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYHQTem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHQTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:34:35 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:51349 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYHQTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:34:34 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200808171934.m7HJYWsv016921@clem.clem-digital.net>
Subject: 27-rc3-git4 fails compile -- security.h
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Sun, 17 Aug 2008 15:34:32 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fyi:
2.6.27-rc3-git4 fails compile:

  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  CC      init/main.o
In file included from init/main.c:32:
include/linux/security.h: In function 'security_ptrace_traceme':
include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)
include/linux/security.h:1760: error: (Each undeclared identifier is reported only once
include/linux/security.h:1760: error: for each function it appears in.)
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

-- 
Pete Clements 
