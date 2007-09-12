Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbXILQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbXILQA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 12:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXILQAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 12:00:20 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:45408 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274AbXILQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 12:00:19 -0400
Date: Wed, 12 Sep 2007 18:00:17 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22.6: still seeing section mismatch warnings
Message-ID: <20070912160017.GA3948@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still seeing the warnings below (2.6.22 started off with lots of
section mismatch warning) but I have no idea if it is safe to ignore
these:

WARNING: arch/i386/kernel/built-in.o(.text+0xea62): Section mismatch: reference to .init.data:trampoline_end (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xea67): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.text+0xea79): Section mismatch: reference to .init.data:trampoline_data (between 'setup_trampoline' and 'cpu_coregroup_map')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x26): Section mismatch: reference to .init.text: (between 'cache_remove_dev' and 'ffh_cstate_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0xee0): Section mismatch: reference to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
WARNING: kernel/built-in.o(.text+0x1b415): Section mismatch: reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')


gcc version 3.4.6 (Debian 3.4.6-5)

-- 
Frank
