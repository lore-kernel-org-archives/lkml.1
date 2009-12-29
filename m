Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZL2UUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZL2UUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 15:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZL2UUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 15:20:05 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:61128 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZL2UUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 15:20:04 -0500
Date: Tue, 29 Dec 2009 15:19:44 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Sid Boyce <sboyce@blueyonder.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** NOT Fixed in
 2.6.33-rc2 either **
In-reply-to: <4B393CDF.5040404@blueyonder.co.uk>
Message-id: <alpine.LFD.2.00.0912291512380.14938@localhost.localdomain>
References: <4B324B76.9020901@blueyonder.co.uk>
 <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk>
 <4B363EEE.8020108@blueyonder.co.uk>
 <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain>
 <4B37F16D.1040000@blueyonder.co.uk> <4B37F3F8.5000108@blueyonder.co.uk>
 <4B38C3AF.1060509@blueyonder.co.uk> <4B393CDF.5040404@blueyonder.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009, Sid Boyce wrote:

> This dmesg is from a freshly built 2.6.32. The following do not appear
> in later 2.6.32-git or 2.6.33-rc kernels.
> # grep LAPIC /DMESG_2.6.32_tindog
> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1]

Right, your local apic is not found, ie this is missing
in the 2.6.33 dmesg:

ACPI: Local APIC address 0xfee00000

Strange, as CONFIG_X86_LOCAL_APIC=y

-Len
Len Brown, Intel Open Source Technology Center


