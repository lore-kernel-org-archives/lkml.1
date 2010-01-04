Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598Ab0ADRXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0ADRXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575Ab0ADRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:23:54 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:60430 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555Ab0ADRXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:23:53 -0500
Message-ID: <4B422426.7090901@blueyonder.co.uk>
Date: Mon, 04 Jan 2010 17:23:50 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.10 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** NOT Fixed
 in 2.6.33-rc2 either **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk> <4B363EEE.8020108@blueyonder.co.uk> <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain> <4B37F16D.1040000@blueyonder.co.uk> <4B37F3F8.5000108@blueyonder.co.uk> <4B38C3AF.1060509@blueyonder.co.uk> <4B393CDF.5040404@blueyonder.co.uk> <alpine.LFD.2.00.0912291512380.14938@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912291512380.14938@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/12/09 20:19, Len Brown wrote:
> On Mon, 28 Dec 2009, Sid Boyce wrote:
> 
>> This dmesg is from a freshly built 2.6.32. The following do not appear
>> in later 2.6.32-git or 2.6.33-rc kernels.
>> # grep LAPIC /DMESG_2.6.32_tindog
>> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
>> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
>> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
>> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1]
> 
> Right, your local apic is not found, ie this is missing
> in the 2.6.33 dmesg:
> 
> ACPI: Local APIC address 0xfee00000
> 
> Strange, as CONFIG_X86_LOCAL_APIC=y
> 
> -Len
> Len Brown, Intel Open Source Technology Center
> 
> 

2.6.33-rc2-git5 booted and showed both CPU's on first boot, on
subsequent boots it hung at HDA irq 22 as it did on earlier kernels.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

