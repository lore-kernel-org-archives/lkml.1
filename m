Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXKUGT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXKUGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXKUGTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:19:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbXKUGTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:19:19 -0500
Date: Tue, 20 Nov 2007 22:18:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-Id: <20071120221839.faab108e.akpm@linux-foundation.org>
In-Reply-To: <4743CC0B.9000508@linux.vnet.ibm.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743CC0B.9000508@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 11:41:23 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Kernel panic's across different architectures like powerpc, x86_64, 

powerpc complains about IO-APICs??

> Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
> Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> Mount-cache hash table entries: 256
> SMP alternatives: switching to UP code
> ACPI: Core revision 20070126
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter

ACPI or x86 breakage, I guess.

Did 'noapic' work?
