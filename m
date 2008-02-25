Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYBYT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYBYT2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYBYT2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:28:02 -0500
Received: from gw.goop.org ([64.81.55.164]:52673 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYBYT2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:28:01 -0500
Message-ID: <47C315CC.5020001@goop.org>
Date: Mon, 25 Feb 2008 11:23:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: compile problem in current x86.git
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/x86/kernel/traps_32.o
/home/jeremy/hg/xen/paravirt/linux/arch/x86/kernel/traps_32.c:59:27: error: asm/kmemcheck.h: No such file or directory


asm-x86/kmemcheck.h does seem to be completely missing.  Looks like 
8db0acefb3025795abe3f37669354677a03de680 "x86: add hooks for kmemcheck" 
should have added the file.

    J
