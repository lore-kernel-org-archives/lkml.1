Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYBOQzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYBOQzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYBOQzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:55:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:55473 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYBOQzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:55:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,358,1199692800"; 
   d="scan'208";a="258094209"
Message-ID: <47B5C38A.5000909@intel.com>
Date: Fri, 15 Feb 2008 08:53:30 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       jack@suse.cz
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <47B5BDC0.3020003@intel.com> <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 16:54:21.0935 (UTC) FILETIME=[6997C7F0:01C86FF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>>>  - network doesn't always come up at first try (e1000e).  On 2.6.24
>>>    e1000e doesn't seem to work at all, so I use e1000, but that has
>>>    other problems.
> 
> It does seem to be using MSI interrupts:
> 
>            CPU0       CPU1
>   0:    2994380          1   IO-APIC-edge      timer
>   1:         24          0   IO-APIC-edge      i8042
>   8:          1          0   IO-APIC-edge      rtc
>   9:       2107          0   IO-APIC-fasteoi   acpi
>  12:       3570          0   IO-APIC-edge      i8042
>  14:         92          0   IO-APIC-edge      ide0
>  16:     124168          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  17:     287458          0   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
>  19:         70          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb5
> 313:      75321          5   PCI-MSI-edge      eth0

OK. can you download, install and run `ethregs -i eth0` (from e1000.sf.net) and
send me the output? I'll compare with a known working t60 I have here and see if
anything shows up.

Also, post me the dmesg from after the adapter fails to load properly.

thanks,

Auke

