Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXJJJLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXJJJLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXJJJLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:11:16 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:54549 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbXJJJLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:11:15 -0400
Message-ID: <470C9731.6030200@free.fr>
Date: Wed, 10 Oct 2007 11:11:13 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
CC: robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr>
In-Reply-To: <470A58AF.9080402@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(The original message seems to have been ignored by the mailing list 
robot, probably because the attachments made it too large. Re-send with 
links instead of attaching the documents to the message.)

John Sigler wrote:

> When I run 'halt' the kernel prints:
> 
> Halting.
> Shutdown: hdc
> ACPI: PCI interrupt for device 0000:01:05.0 disabled
> ACPI: PCI interrupt for device 0000:01:04.0 disabled
> ACPI: PCI interrupt for device 0000:01:03.0 disabled
> ACPI: PCI interrupt for device 0000:01:02.0 disabled
> Power down.
> acpi_power_off called
> 
> But the system does not shut down. (The fans keep spinning, the LEDs 
> keep shining, the LCD keeps displaying.) Basically, the motherboard is 
> still providing power to every component, as if the power supply had 
> refused to stop.
> 
> Kernel is 2.6.22.1-rt9
> 
> I followed the instructions given here:
> http://bugzilla.kernel.org/show_bug.cgi?id=6431
> 
> # cat /sys/module/acpi/parameters/debug_layer
> Description                     Hex        SET
> ACPI_UTILITIES                  0x00000001 [*]
> ACPI_HARDWARE                   0x00000002 [*]
> ACPI_EVENTS                     0x00000004 [*]
> ACPI_TABLES                     0x00000008 [*]
> ACPI_NAMESPACE                  0x00000010 [*]
> ACPI_PARSER                     0x00000020 [*]
> ACPI_DISPATCHER                 0x00000040 [*]
> ACPI_EXECUTER                   0x00000080 [*]
> ACPI_RESOURCES                  0x00000100 [*]
> ACPI_CA_DEBUGGER                0x00000200 [*]
> ACPI_OS_SERVICES                0x00000400 [*]
> ACPI_CA_DISASSEMBLER            0x00000800 [*]
> ACPI_COMPILER                   0x00001000 [*]
> ACPI_TOOLS                      0x00002000 [*]
> ACPI_ALL_DRIVERS                0xFFFF0000 [*]
> -- 
> debug_layer = 0xFFFF3FFF ( * = enabled)
> 
> # cat /sys/module/acpi/parameters/debug_level
> Description                     Hex        SET
> ACPI_LV_ERROR                   0x00000001 [*]
> ACPI_LV_WARN                    0x00000002 [*]
> ACPI_LV_INIT                    0x00000004 [*]
> ACPI_LV_DEBUG_OBJECT            0x00000008 [*]
> ACPI_LV_INFO                    0x00000010 [*]
> ACPI_LV_INIT_NAMES              0x00000020 [*]
> ACPI_LV_PARSE                   0x00000040 [*]
> ACPI_LV_LOAD                    0x00000080 [*]
> ACPI_LV_DISPATCH                0x00000100 [*]
> ACPI_LV_EXEC                    0x00000200 [*]
> ACPI_LV_NAMES                   0x00000400 [*]
> ACPI_LV_OPREGION                0x00000800 [*]
> ACPI_LV_BFIELD                  0x00001000 [*]
> ACPI_LV_TABLES                  0x00002000 [*]
> ACPI_LV_VALUES                  0x00004000 [*]
> ACPI_LV_OBJECTS                 0x00008000 [*]
> ACPI_LV_RESOURCES               0x00010000 [*]
> ACPI_LV_USER_REQUESTS           0x00020000 [*]
> ACPI_LV_PACKAGE                 0x00040000 [*]
> ACPI_LV_ALLOCATIONS             0x00100000 [*]
> ACPI_LV_FUNCTIONS               0x00200000 [*]
> ACPI_LV_OPTIMIZATIONS           0x00400000 [*]
> ACPI_LV_MUTEX                   0x01000000 [*]
> ACPI_LV_THREADS                 0x02000000 [*]
> ACPI_LV_IO                      0x04000000 [*]
> ACPI_LV_INTERRUPTS              0x08000000 [*]
> ACPI_LV_AML_DISASSEMBLE         0x10000000 [*]
> ACPI_LV_VERBOSE_INFO            0x20000000 [*]
> ACPI_LV_FULL_TABLES             0x40000000 [*]
> ACPI_LV_EVENTS                  0x80000000 [*]
> -- 
> debug_level = 0xFFFFFFFF (* = enabled)

http://linux.kernel.free.fr/halt/config-2.6.22.1-rt9
http://linux.kernel.free.fr/halt/acpidump.txt
http://linux.kernel.free.fr/halt/dmesg.txt
http://linux.kernel.free.fr/halt/halt.txt
http://linux.kernel.free.fr/halt/lspci.txt

Do you know what could be the problem?
(Meanwhile, I will investigate Remy Bohmer's suggestion.)

Regards.
