Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXHOXft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXHOXft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbXHOXfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:35:38 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:38574 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761783AbXHOXfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:35:37 -0400
Date: Wed, 15 Aug 2007 17:35:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: dual Xeon hyperthread system only showing up as 2 cpus
In-reply-to: <fa.5IVbZBqVHBgyu8BpsYPjQ9pqQ5M@ifi.uio.no>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46C38DB2.9040400@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.5IVbZBqVHBgyu8BpsYPjQ9pqQ5M@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> 
> Hi all,
> 
> I've got a system that has two hyperthread-capable Xeons.  If I boot it 
> with 2.6.10 it shows up as 4 cpus, but with 2.6.14 it only shows 2 cpus.
> 
> The relevent boot logs are:
> 
> 2.6.10:
> 
> DMI 2.3 present.
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Processor #0 15:2 APIC version 20
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
> Processor #6 15:2 APIC version 20
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
> Processor #1 15:2 APIC version 20
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
> Processor #7 15:2 APIC version 20
> Using ACPI for processor (LAPIC) configuration information
> Intel MultiProcessor Specification v1.4
>     Virtual Wire compatibility mode.
> <snip>
> Processors: 4
> 
> 
> 2.6.14:
> 
> DMI 2.3 present.
> Intel MultiProcessor Specification v1.4
>     Virtual Wire compatibility mode.
> OEM ID: INTEL    Product ID: KingsCanyonC APIC at: 0xFEE00000
> Processor #0 15:2 APIC version 20
> Processor #6 15:2 APIC version 20
> <snip>
> Processors: 2

You snipped the important part of the log. It's not using ACPI in 2.6.14 
for some reason, which you need for HT to be detected. Either you didn't 
configure it in or it's failed to enable somehow. Please post the entire 
dmesg.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

