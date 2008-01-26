Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYAZWTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYAZWTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYAZWTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:19:47 -0500
Received: from fisica.ufpr.br ([200.17.209.129]:53024 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYAZWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:19:46 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2008 17:19:46 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18331.45568.100640.631471@fisica.ufpr.br>
Date: Sat, 26 Jan 2008 20:19:44 -0200
To: linux-kernel@vger.kernel.org
Subject: build warning in 2.6.24: section mismatch
X-Mailer: VM 7.19 under Emacs 22.1.1
From: carlos@fisica.ufpr.br (Carlos Carvalho)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Near the end of the build this appears:

  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
  LD      vmlinux
  SYSMAP  System.map

What does this mean?

The build finishes and the machine has been running for about 50min.
