Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbXBACw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbXBACw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 21:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXBACw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 21:52:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:37535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933366AbXBACw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 21:52:28 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Sunil Naidu" <akula2.shark@gmail.com>
Subject: Re: 2.6.20-rc6-mm3 - interesting dmesg
Date: Wed, 31 Jan 2007 21:50:58 -0500
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org
References: <8355959a0701300352l27911a14t853e8dea5fcd820d@mail.gmail.com>
In-Reply-To: <8355959a0701300352l27911a14t853e8dea5fcd820d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701312150.58343.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 06:52, Sunil Naidu wrote:
> Hi Andrew,
> 
> I did compile the same, it's a trouble free boot. I did observe
> interesting changes in the dmesg between 2.6.20-rc6 & 2.6.20-rc6-mm3
> (wondering why there are so many changes in the output). Anyway, the
> changes in brief:-
> 
> a) ACPI values

The new ACPI messages are normal.
They are the result of new table management code.

thanks,
-Len

> b) pnp - iomem range reserved values
> c) Drive selection (hda, hdb)
> d) USB Subsystem - (usb1, usb2, usb3, usb4, usb5, usb 2-1) - new
> devices found.
> e) EXT3-fs - warning - maximal_mount_count reached (???)
> 
> Here is the dmesg info:-

> ACPI: RSDP @ 0x000f4eb0/0x0014 (v000 ACPIAM)
> ACPI: RSDT @ 0x1f730000/0x003C (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097)
> ACPI: FACP @ 0x1f730200/0x0081 (v002 INTEL  D915GAV  0x20060222 MSFT 0x00000097)
> ACPI: DSDT @ 0x1f730440/0x5C05 (v001 INTEL  D915GAV  0x00000001 INTL 0x02002026)
> ACPI: FACS @ 0x1f740000/0x0040
> ACPI: APIC @ 0x1f730390/0x0068 (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097)
> ACPI: MCFG @ 0x1f730400/0x003C (v001 INTEL  D915GAV  0x20060222 MSFT 0x00000097)
> ACPI: ASF! @ 0x1f736050/0x0099 (v016 LEGEND I865PASF 0x00000001 INTL 0x02002026)
> ACPI: TCPA @ 0x1f7360f0/0x0032 (v001 INTEL  TBLOEMID 0x00000001 MSFT 0x00000097)
> ACPI: WDDT @ 0x1f736122/0x0040 (v001 INTEL  OEMWDDT  0x00000001 INTL 0x02002026)

