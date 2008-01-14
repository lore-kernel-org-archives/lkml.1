Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYANWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYANWQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYANWQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:16:11 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:38577 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYANWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:10 -0500
Date: Mon, 14 Jan 2008 23:16:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, sam@ravnborg.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Latest git-x86 doesn't build on 32bit
Message-ID: <20080114221608.GA11732@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Jan 2008 22:09:57.0370 (UTC) FILETIME=[32C5DDA0:01C856FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a fresh object dir I get for a 32bit build:

make -C /home/lsrc/quilt/linux O=/home/lsrc/quilt/obj32 
  GEN     /home/lsrc/quilt/obj32/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  Using /home/lsrc/quilt/linux as source for kernel
  CALL    /home/lsrc/quilt/linux/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  Building modules, stage 2.
  MODPOST 1 modules
make[3]: Nothing to be done for `vmlinux'.
KBUILD_IMAGE := arch/x86/boot/bzImage
make[2]: KBUILD_IMAGE: Command not found
make[2]: *** [all] Error 127
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

I think it worked on older object dirs where not everything was rebuild.

make --version
GNU Make 3.81


-Andi
