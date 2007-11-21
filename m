Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXKUTYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXKUTYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXKUTYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:24:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:49400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbXKUTYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:24:23 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Date: Wed, 21 Nov 2007 14:22:32 -0500
User-Agent: KMail/1.9.5
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org>
In-Reply-To: <20071120221839.faab108e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711211422.32908.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 01:18, Andrew Morton wrote:
> On Wed, 21 Nov 2007 11:41:23 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> > SMP alternatives: switching to UP code
> > ACPI: Core revision 20070126
> > ..MP-BIOS bug: 8254 timer not connected to IO-APIC

did previous kernels print this too?

> > Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
> 
> ACPI or x86 breakage, I guess.

If you suspect ACPI breakage, then try "acpi=off" or "acpi=noirq".

thanks,
-Len
