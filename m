Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbXGSMzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbXGSMzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbXGSMzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:55:07 -0400
Received: from il.qumranet.com ([82.166.9.18]:45795 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXGSMzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:55:06 -0400
Message-ID: <469F5F31.2030809@qumranet.com>
Date: Thu, 19 Jul 2007 15:55:13 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-30 release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This kvm release introduces guest smp.  I've tested 4-way Linux (64-bit 
and 32-bit) and 2-way Windows XP.  A kernel build on 2-way 64-bit Linux 
is 40% faster that on a uniprocessor guest.  Expect performance to 
improve as the in-kernel apic work is merged and as we tune kvm for smp.

Changes from kvm-29:
- minor fixes and cleanups  (Jeff Dike, Rusty Russell, me)
- kernel pio string write (Eddie Dong)
- guest smp kernel fixes
- rdmsr and wrmsr real mode emulation
- fix real mode shadow pages aliasing nx large page shadows
- enable guest smp in qemu
- fix external module installer
- revert ide enable changes that caused an I/O regression

Notes:
    If you use the modules from kvm-30, you can use any version of Linux
from 2.6.9 upwards.
    If you use the modules from Linux 2.6.20, you need to use kvm-12.
    If you use the modules from Linux 2.6.21, you need to use kvm-17.
    Modules from Linux 2.6.22 and up will work with any kvm version from
kvm-22.  Some features may only be available in newer releases.

http://kvm.qumranet.com


