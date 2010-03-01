Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0CASjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:39:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0CASjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:39:11 -0500
Message-ID: <4B8C096E.4080201@kernel.org>
Date: Mon, 01 Mar 2010 10:37:34 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, garyhade@us.ibm.com,
       iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       trenn@suse.de
Subject: Re: [LKML] Re: [tip:x86/apic] x86: Fix out of order gsi -- add	remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org> <4B897537.5050406@kernel.org> <m1zl2ue585.fsf@fess.ebiederm.org> <20100301164602.GG7881@phenom.dumpdata.com>
In-Reply-To: <20100301164602.GG7881@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 08:46 AM, Konrad Rzeszutek Wilk wrote:
>>
>>> so far this patch only affect (fix ) x3950.
> 
> .. snip ..
>>> other solution will ask IBM to fix their bios, so we can get
> 
> It isn't just IBM. Asus P2B-D (PIIX4) and SuperMicro X8DAL (possibly)
> seem to have the same issue.
> 
> (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg00715.html)
> and
> (http://lists.xensource.com/archives/html/xen-devel/2010-02/msg01239.html)

looks it is different...
their ioapic is sane...

ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low level)
