Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYBEFeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYBEFeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYBEFdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:33:55 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:41877 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYBEFdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:33:54 -0500
Message-ID: <47A7F53C.8090606@in.ibm.com>
Date: Tue, 05 Feb 2008 11:03:48 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, bwalle@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
References: <47A7391F.2020408@in.ibm.com> <20080204183810.GE16021@redhat.com> <20080204193524.GA11104@suse.de>
In-Reply-To: <20080204193524.GA11104@suse.de>
Content-Type: multipart/mixed;
 boundary="------------040902040104010200030102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040902040104010200030102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@redhat.com> [2008-02-04 19:38]:
>   
>> Bernahard, any idea who is the competitor here?
>>     
> Hm ..., can you boot the kernel without crashkernel= and provide the
> /proc/iomem?
>   
Attached is the /proc/iomem output with and without crashkernel
parameter.

Adding debug gives this extra information.

hm, page 02a9d000 reserved twice.
crashkernel reservation failed - memory is in use

Will try to add more debug statements.

Thanks
-Sachin



--------------040902040104010200030102
Content-Type: text/plain;
 name="iomem_with_crashkernel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iomem_with_crashkernel"

00000000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000e0000-000fffff : reserved
00100000-c7fcadff : System RAM
  00200000-004780d6 : Kernel code
  004780d7-0059e867 : Kernel data
  008a2000-009969ab : Kernel bss
c7fcae00-c7fcf7ff : ACPI Tables
c7fcf800-c7ffffff : reserved
c8000000-c9ffffff : PCI Bus #07
  c9ff0000-c9ffffff : 0000:07:00.0
    c9ff0000-c9ffffff : tg3
ca000000-cbbfffff : PCI Bus #06
  cbbf0000-cbbfffff : 0000:06:00.0
    cbbf0000-cbbfffff : tg3
cbc00000-cdafffff : PCI Bus #02
  cbc00000-cbffffff : PCI Bus #04
  cc000000-cdafffff : PCI Bus #03
cdb00000-cfffffff : PCI Bus #02
  cdb00000-cdefffff : PCI Bus #04
  cdfff000-cdffffff : 0000:02:00.2
    cdfff000-cdfff027 : shpchp
  ce000000-cfffffff : PCI Bus #03
    cfffc000-cfffdfff : 0000:03:07.1
      cfffc000-cfffcfff : aic79xx
    cfffe000-cfffffff : 0000:03:07.0
      cfffe000-cfffefff : aic79xx
d0000000-ddffffff : PCI Bus #01
  d0000000-d7ffffff : 0000:01:06.0
de000000-dfffffff : PCI Bus #01
  dfff0000-dfffffff : 0000:01:06.0
e0000000-efffffff : PCI MMCONFIG 0
f0000000-f00003ff : 0000:00:1d.7
  f0000000-f00003ff : ehci_hcd
f0000400-f00007ff : 0000:00:1f.1
fec00000-fec00fff : IOAPIC 0
fec80000-fec80fff : IOAPIC 1
fed20800-fed208ff : pnp 00:0e
fed30800-fed308ff : pnp 00:0e
fee00000-fee00fff : Local APIC
ff000000-ff000fff : 0000:00:00.0
  ff000000-ff000fff : pnp 00:0e
fff00000-ffffffff : pnp 00:0e
100000000-237ffffff : System RAM

--------------040902040104010200030102
Content-Type: text/plain;
 name="iomem_without_crashkernel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iomem_without_crashkernel"

00000000-0009dbff : System RAM
0009dc00-0009ffff : reserved
000e0000-000fffff : reserved
00100000-c7fcadff : System RAM
  00200000-004780d6 : Kernel code
  004780d7-0059e867 : Kernel data
  008a2000-009969ab : Kernel bss
c7fcae00-c7fcf7ff : ACPI Tables
c7fcf800-c7ffffff : reserved
c8000000-c9ffffff : PCI Bus #07
  c9ff0000-c9ffffff : 0000:07:00.0
    c9ff0000-c9ffffff : tg3
ca000000-cbbfffff : PCI Bus #06
  cbbf0000-cbbfffff : 0000:06:00.0
    cbbf0000-cbbfffff : tg3
cbc00000-cdafffff : PCI Bus #02
  cbc00000-cbffffff : PCI Bus #04
  cc000000-cdafffff : PCI Bus #03
cdb00000-cfffffff : PCI Bus #02
  cdb00000-cdefffff : PCI Bus #04
  cdfff000-cdffffff : 0000:02:00.2
    cdfff000-cdfff027 : shpchp
  ce000000-cfffffff : PCI Bus #03
    cfffc000-cfffdfff : 0000:03:07.1
      cfffc000-cfffcfff : aic79xx
    cfffe000-cfffffff : 0000:03:07.0
      cfffe000-cfffefff : aic79xx
d0000000-ddffffff : PCI Bus #01
  d0000000-d7ffffff : 0000:01:06.0
de000000-dfffffff : PCI Bus #01
  dfff0000-dfffffff : 0000:01:06.0
e0000000-efffffff : PCI MMCONFIG 0
f0000000-f00003ff : 0000:00:1d.7
  f0000000-f00003ff : ehci_hcd
f0000400-f00007ff : 0000:00:1f.1
fec00000-fec00fff : IOAPIC 0
fec80000-fec80fff : IOAPIC 1
fed20800-fed208ff : pnp 00:0e
fed30800-fed308ff : pnp 00:0e
fee00000-fee00fff : Local APIC
ff000000-ff000fff : 0000:00:00.0
  ff000000-ff000fff : pnp 00:0e
fff00000-ffffffff : pnp 00:0e
100000000-237ffffff : System RAM

--------------040902040104010200030102--
