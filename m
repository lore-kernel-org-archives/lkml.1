Return-Path: <linux-kernel-owner+w=401wt.eu-S1765867AbXILVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765867AbXILVt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXILVtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:49:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:52007 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbXILVts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CYVKjiZkkqWvsPRNx6qvXZH1luFy5LjKlvNCbXffuvLjoFgki8q/0pgySFOlzlNrVGW0Cal1xOs+iYa0R8OUjS60/zrt/vZfuSDSG+Ra7DHpPhlSOb/TScJbPymGpESsUb/wWAcAvJ03A82iyD5MiBjMiTT86j4PgCU/jb+ctDY=
Message-ID: <46E85EF5.7050306@gmail.com>
Date: Thu, 13 Sep 2007 01:49:41 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc5 hangs on boot, apparently when initializing the EC
References: <46E6F30C.5040500@redhat.com>
In-Reply-To: <46E6F30C.5040500@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck,

Please try last patch from bug 8709 (bugzilla.kernel.org), if it does not help, please open new bug, 
and submit acpidump and dmesg outputs.

Thanks,
Alex.

 
Chuck Ebbert wrote:
> 2.6.23-rc5-git1 hangs here, just before EC initialization.
> Pressing the power button briefly makes it continue, then the
> EC gets detected twice:
> 
> 
> ACPI: bus type pci registered
> PCI: Using configuration type 1
> 
> ------------------ hangs here, press power button --------------------
> 
> ACPI: EC: Look up EC in DSDT
> ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
> ACPI: System BIOS is requesting _OSI(Linux)
> ACPI: If "acpi_osi=Linux" works better,
> Please send dmidecode to linux-acpi@vger.kernel.org
> ACPI: Interpreter enabled
> ACPI: (supports S0 S3)
> ACPI: Using IOAPIC for interrupt routing
> ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Transparent bridge - 0000:00:10.0
> ...
> 
> 
> System is an HP TX1000 notebook with AMD Turion X2 processor,
> running the x86_64 kernel. (And acpi_osi="Linux" doesn't seem to
> make any difference.)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

