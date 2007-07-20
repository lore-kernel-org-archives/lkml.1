Return-Path: <linux-kernel-owner+w=401wt.eu-S1763795AbXGTMZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763795AbXGTMZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbXGTMZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:25:32 -0400
Received: from fonzie.hosting9000.com ([85.214.50.12]:52519 "EHLO
	fonzie.hosting9000.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbXGTMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:25:31 -0400
Message-ID: <46A0A954.4020102@googlemail.com>
Date: Fri, 20 Jul 2007 14:23:48 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/Kconfig MEMORY_HOTPLUG typo ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm a bit confused about the following from mm/Kconfig:

..

config MEMORY_HOTPLUG
        bool "Allow for memory hot-add"
        depends on SPARSEMEM || X86_64_ACPI_NUMA
        depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
        depends on (IA64 || X86 || PPC64 || SUPERH)

comment "Memory hotplug is currently incompatible with Software Suspend"
        depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND


...

That should be !SOFTWARE_SUSPEND no ?


Regards,

Gabriel C
