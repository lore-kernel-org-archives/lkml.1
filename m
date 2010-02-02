Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0BBJ7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 04:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0BBJ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 04:59:21 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: IRQ regression messes up xseries 330 SCI resulting in apic=off - bisected to commit b9c61b70075c87a861262473
Date: Tue, 2 Feb 2010 10:59:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, mingo@elte.hu
References: <201002011559.07869.trenn@suse.de> <4B677CFC.9080406@kernel.org> <4B67DC58.7060809@kernel.org>
In-Reply-To: <4B67DC58.7060809@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002021059.18939.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010 09:03:36 Yinghai Lu wrote:
> On 02/01/2010 05:16 PM, Yinghai Lu wrote:
> > On 02/01/2010 06:59 AM, Thomas Renninger wrote:
> >> Hi,
> >>
> >> booting a latest kernel on this machine results in:
> >>
> >> PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
> >> PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
> >> ACPI: SCI (IRQ30) allocation failed
> >> ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
> >> ACPI: Unable to start the ACPI Interpreter
> >>
> > 
> > please check
> 
> Subject: [PATCH -v2] x86: fix sci on ioapic 1
Works for me, thanks!
Tested-by: Thomas Renninger <trenn@suse.de>

Is this supposed to go into 2.6.33 still?
Do you consider this save enough to CC: stable@kernel.org and just
push it/commit it there?
I can confirm that this one patches and works fine for 2.6.32.
2.6.31 would also need this fix, the regression was introduced somewhere
between 2.6.30 and 2.6.31.

Thanks again,

    Thomas
