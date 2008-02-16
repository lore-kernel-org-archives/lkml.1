Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYBPRtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYBPRtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYBPRtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:49:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38470 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbYBPRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:49:17 -0500
Date: Sat, 16 Feb 2008 09:48:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, pavel@suse.cz, rjw@sisk.pl
Subject: Re: 2.6.25-rc2-mm1 (wakeup)
Message-Id: <20080216094844.3e5224f0.randy.dunlap@oracle.com>
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

The ACPI wakeup in C patch (I think) won't build for me on x86_32
(i.e., i386 build on x86_64 system):

linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: -mpreferred-stack-boundary=2 is not between 4 and 12
make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.o] Error 1
make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2

---
~Randy
