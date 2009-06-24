Return-Path: <linux-kernel-owner+w=401wt.eu-S1761858AbZFXTnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761858AbZFXTnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761012AbZFXTmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:42:51 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52615 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704AbZFXTmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:42:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YcHnEWoadHN7hPEYNsy/rF41fOtgcD/ygZkqNXZI83uAoTJgFpcPKxXxB9frzb5b7J
         QYrmbdnC5g5Y+uKPhYmTT1EvhSFUNvoL+ybIWZ19SckEinPTBUn2xneAYK2xon4HlADT
         kYwnMp72NHHtSOAB9umoOFxAWIFb+SSI8WH4E=
MIME-Version: 1.0
In-Reply-To: <20090624123241.01ca4fec@jbarnes-g45>
References: <dd18b0c30906241027u152274b1kd4c854ada4de33dd@mail.gmail.com>
	 <20090624123241.01ca4fec@jbarnes-g45>
Date: Wed, 24 Jun 2009 12:42:52 -0700
Message-ID: <dd18b0c30906241242p6bbf6918r5f53abb256fd155c@mail.gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 6: no parent found for of device 
	[0xfffe0000-0xffffffff]
From: Justin Mattock <justinmattock@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 12:32 PM, Jesse Barnes<jbarnes@virtuousgeek.org> wrote:
> On Wed, 24 Jun 2009 10:27:42 -0700
> Justin Mattock <justinmattock@gmail.com> wrote:
>
>> (just pulled the latest git)
>> And am seeing this:
>>
>>
>> [    0.696001] pci 0000:01:00.0: BAR 6: no parent found for of device
>> [0xfffe0000-0xffffffff]
>> [    0.696010] pci 0000:02:00.0: BAR 6: no parent found for of device
>> [0xfffe0000-0xffffffff]
>> [    0.696069] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
>> [    0.696074] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
>> [    0.696081] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
>> [    0.696087] pci 0000:00:01.0:   PREFETCH window:
>> 0x00000040000000-0x00000047ffffff
>> [    0.696096] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
>> [    0.696102] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
>> [    0.696111] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
>> [    0.696118] pci 0000:00:1c.0:   PREFETCH window:
>> 0x50500000-0x505fffff [    0.696126] pci 0000:00:1c.1: PCI bridge,
>> secondary bus 0000:03 [    0.696130] pci 0000:00:1c.1:   IO window:
>> disabled [    0.696138] pci 0000:00:1c.1:   MEM window:
>> 0x50100000-0x501fffff [    0.696145] pci 0000:00:1c.1:   PREFETCH
>> window: disabled [    0.696152] pci 0000:00:1c.2: PCI bridge,
>> secondary bus 0000:04 [    0.696158] pci 0000:00:1c.2:   IO window:
>> 0x1000-0x1fff [    0.696167] pci 0000:00:1c.2:   MEM window:
>> 0x4c100000-0x500fffff [    0.696174] pci 0000:00:1c.2:   PREFETCH
>> window: 0x00000048000000-0x0000004bffffff
>> [    0.696186] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
>> [    0.696190] pci 0000:00:1e.0:   IO window: disabled
>> [    0.696198] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
>> [    0.696205] pci 0000:00:1e.0:   PREFETCH window: disabled
>> [    0.696219] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) ->
>> IRQ 16 [    0.696225] pci 0000:00:01.0: setting latency timer to 64
>> [    0.696235] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) ->
>> IRQ 17 [    0.696243] pci 0000:00:1c.0: setting latency timer to 64
>> [    0.696254] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) ->
>> IRQ 16 [    0.696261] pci 0000:00:1c.1: setting latency timer to 64
>> [    0.696273] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) ->
>> IRQ 18 [    0.696280] pci 0000:00:1c.2: setting latency timer to 64
>> [    0.696437] pci 0000:00:1e.0: power state changed by ACPI to D0
>> [    0.696446] pci 0000:00:1e.0: setting latency timer to 64
>>
>>
>> Is this good or bad?
>> (BAR 6: no parent found for of device)
>
> There have been a few changes in this area recently, notably
>
> commit 9e9f46c44e487af0a82eb61b624553e2f7118f5b
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Thu Jun 11 10:58:28 2009 -0700
>
>    PCI: use ACPI _CRS data by default
>
> and some related to
>
> commit ff54250a0ebab7f90a5f848a0ba63f999830c872
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sat Apr 18 21:44:24 2009 -0700
>
>    Remove 'recurse into child resources' logic from ...
>
> The first you can control with the nocrs boot param, the other ones
> will have to be bisected through though...
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>

output from lspci is:


01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon
Mobility X1600]
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053
PCI-E Gigabit Ethernet Controller (rev 22)
(if I'm reading this correctly)

I can try nocrs to see if it hides this or fixes this message,
if not I can try the whole bisect thing(not sure If I can since
I just cloned the kernel a few days ago, and didn't put any good
or bad tags on the commit)

As for the system itself, seems fine(except for this
message) been streaming radio without any issues for
a while now.

-- 
Justin P. Mattock
