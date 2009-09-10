Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZIJKRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZIJKRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZIJKRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:17:00 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:61251 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbZIJKQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gfB1OjxGIDficFavgxCIR+RAyk9y98qgMSWTfI3qrJffw8EmdUqN4m4XP7zdHlj0oM
         NhPDbhpX05dqFzRflsjcb+SuCwsbEshe/RfFc5Hrs2R8GgiDXWMZZjP5uRm3hqu0+z64
         zc/vp8S9mMiq/pHn2xFSb1Q3G1TTWGvttkDCE=
MIME-Version: 1.0
In-Reply-To: <4911F71203A09E4D9981D27F9D830858149BBB4F@orsmsx503.amr.corp.intel.com>
References: <6278d2220902170831n3801a935x578b5dff64d00c62@mail.gmail.com>
	 <4911F71203A09E4D9981D27F9D830858149BBB4F@orsmsx503.amr.corp.intel.com>
Date: Thu, 10 Sep 2009 11:17:01 +0100
Message-ID: <6278d2220909100317y1266021bla5e9f24e13a64f1b@mail.gmail.com>
Subject: Re: [2.6.29-rc5 ACPI] truncated dsobject list...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 7:48 PM, Moore, Robert <robert.moore@intel.com> wrote:
>>ACPI Warning (dsobject-0502): Package List length (6) larger than
>>NumElements count (4), truncated
>
> This simply means that in one of the ACPI tables, a Package object was found that was declared to have 6 items. However, when parsing the package, the interpreter only found 4 items.
>
> It's a BIOS issue, but probably not serious unless there really is supposed to be 6 items.

I see this with stock 2.6.31 [1] on Intel S5400SF hardware. I'll send
you the acpidump offline.

Thanks,
  Daniel

--- [1]

$ dmesg
ACPI: RSDP 00000000000f03f0 00024 (v02 INTEL )

ACPI: XSDT 000000007fb39120 0008C (v01 INTEL  S5400SF  00000000 INTL 01000013)

ACPI: DMAR 000000007fb37000 00112 (v01 INTEL  S5400SF  00000001 INTL 01000013)

ACPI: FACP 000000007fb35000 000F4 (v03 INTEL  S5400SF  00000000 INTL 01000013)

ACPI: DSDT 000000007fb2e000 05664 (v02 INTEL  S5400SF  00000008 INTL 01000013)

ACPI: FACS 000000007fabf000 00040

ACPI: APIC 000000007fb34000 000C8 (v01 INTEL  S5400SF  00000000 INTL 01000013)

ACPI: SPCR 000000007fb2d000 00050 (v01 INTEL  S5400SF  00000000 INTL 01000013)

ACPI: HPET 000000007fb2c000 00038 (v01 INTEL  S5400SF  00000001 INTL 01000013)

ACPI: MCFG 000000007fb2b000 0003C (v01 INTEL  S5400SF  00000001 INTL 01000013)

ACPI: SSDT 000000007fb2a000 00A14 (v02 INTEL  EIST     00004000 INTL 01000013)

ACPI: SSDT 000000007fb29000 00193 (v02 INTEL  IPMI     00004000 INTL 01000013)

ACPI: SSDT 000000007fb28000 002D4 (v02 INTEL  CST      00004000 INTL 01000013)

ACPI: HEST 000000007fb27000 000A8 (v01 INTEL  S5400SF  00000001 INTL 00000001)

ACPI: BERT 000000007fb26000 00030 (v01 INTEL  S5400SF  00000001 INTL 00000001)

ACPI: ERST 000000007fb25000 00230 (v01 INTEL  S5400SF  00000001 INTL 00000001)

ACPI: EINJ 000000007fb24000 00130 (v01 INTEL  S5400SF  00000001 INTL 00000001)

<snip>
ACPI: EC: Look up EC in DSDT

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502

ACPI Warning: Package List length (6) larger than NumElements count
(2), truncated

 20090521 dsobject-502


>>-----Original Message-----
>>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>>owner@vger.kernel.org] On Behalf Of Daniel J Blueman
>>Sent: Tuesday, February 17, 2009 8:32 AM
>>To: linux-acpi@vger.kernel.org; Linux Kernel
>>Subject: [2.6.29-rc5 ACPI] truncated dsobject list...
>>
>>With 2.6.29-rc5 on an Intel S5000PAL server (BIOS
>>S5000.86B.10.60.0091.100920081631), we see ACPI object list truncation
>>[1]. Does it make sense to increase the default element allocation?
>>
>>Many thanks,
>>  Daniel
>>
>>--- [1]
>>
>>ACPI: EC: Look up EC in DSDT
>>ACPI Warning (dsobject-0502): Package List length (6) larger than
>>NumElements count (4), truncated
>>[20081204]
-- 
Daniel J Blueman
