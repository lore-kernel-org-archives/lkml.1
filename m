Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZLALRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZLALRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 06:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZLALRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 06:17:38 -0500
Received: from mail.turknet.net.tr ([193.192.98.182]:9366 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLALRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 06:17:37 -0500
X-Greylist: delayed 4502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 06:17:37 EST
Message-ID: <4B14FB56.4040608@netone.com.tr>
Date: Tue, 01 Dec 2009 13:17:42 +0200
From: Tarkan Erimer <tarkane@netone.com.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.8 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] Linux-2.6.32-rc8-git2 Fails To Compile With GCC-4.4.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2009 11:17:43.0476 (UTC) FILETIME=[E6F1C740:01CA7277]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to compile linux-2.6.32-rc8-git2 with gcc-4.2.2 on opensuse
11.2. But, it failed with the following error :

PS: When I googled, I found the same error on Ubuntu Lucid forums with
gcc-4.4.2, too.


GZIP kernel/config_data.gz
CC kernel/stop_machine.o
CC [M] arch/x86/kvm/../../../virt/kvm/kvm_main.o
CC kernel/audit.o
CC kernel/auditfilter.o
CC [M] arch/x86/kvm/../../../virt/kvm/ioapic.o
CC [M] arch/x86/kvm/../../../virt/kvm/coalesced_mmio.o
CC kernel/audit_watch.o
CC [M] arch/x86/kvm/../../../virt/kvm/irq_comm.o
CC kernel/auditsc.o
CC [M] arch/x86/kvm/../../../virt/kvm/eventfd.o
CC [M] arch/x86/kvm/x86.o
CC kernel/audit_tree.o
kernel/audit_tree.c: In function ‘find_chunk’:
kernel/audit_tree.c:206: internal compiler error: Segmentation fault
Please submit a full bug report,
with preprocessed source if appropriate.


tarkane:/usr/src/linux-2.6.32-rc8-git2 # gcc --version
gcc (SUSE Linux) 4.4.2 [gcc-4_4-branch revision 153890]
Copyright (C) 2009 Free Software Foundation, Inc.
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

