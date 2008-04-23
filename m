Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYDWWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYDWWe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYDWWet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:34:49 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:60723 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYDWWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rle5G6VOmu8bzyJN90GYgtOutdM3g1gWFoWulTj4CdGUFxEk8NPeWtFEc5FRlqev0cU9jwrXkQ/YSdJO3IKlup+Uan89n4d4s6sJCIU3L2LjZYlEakpMEosFxZuvlgUwMOJmSQuvn3E21utMbQKW7NBT9sqJxwParz8OoSXrbxA=
Message-ID: <dd18b0c30804231534j6eeb5661sfaf0889d4dbfbdc0@mail.gmail.com>
Date: Wed, 23 Apr 2008 22:34:47 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: BIOS bug, APIC version is 0 for CPU#0!
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <480FA1EF.7080400@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480F2842.4010505@googlemail.com>
	 <dd18b0c30804231106i4fddd518k3c81df0f267c9ab2@mail.gmail.com>
	 <480FA1EF.7080400@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 8:54 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Justin Mattock wrote:
>  > On Wed, Apr 23, 2008 at 12:14 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
>  >> Hi,
>  >>
>  >>  I've just compiled latest linus git tree and getting now on an Q9300 Core2Quad , ASUS P5E-VM DO motherboard with BIOS Ver. 0606 , BIOS Rev. 8.12
>  >>  the BIOS bug for CPU#0 message for each processor ?!? That seems somewhat buggy ?:)
>  >>
>  >>  That BIOS version is beta and may be really buggy but I never got such a message on 2.6.24* nor on 2.6.25.
>  >>
>  >>
>  >>  --($:~)-- uname -a
>  >>  Linux thor 2.6.25-03530-g94bc891 #773 SMP PREEMPT Wed Apr 23 13:55:10 CEST 2008 i686 GNU/Linux
>  >>
>  >>
>  >>  ..
>  >>
>  >>  [    0.000000] ACPI: PM-Timer IO Port: 0x808
>  >>  [    0.000000] ACPI: Local APIC address 0xfee00000
>  >>  [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>  >>  [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  >>  [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>  >>  [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  >>  [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>  >>  [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  >>  [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>  >>  [    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
>  >>  [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
>  >>  [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
>  >>  [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>  >>  [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>  >>  [    0.000000] ACPI: IRQ0 used by override.
>  >>  [    0.000000] ACPI: IRQ2 used by override.
>  >>  [    0.000000] ACPI: IRQ9 used by override.
>  >>  [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
>  >>  [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
>  >>  [    0.000000] Using ACPI (MADT) for SMP configuration information
>  >>
>  >>  ...
>  >>
>  >>  Please let me know if you need more infos , dmesg , config etc .
>  >>
>  ..
>  >
>  > Hello; I'm receiving the same thing, I received a response and it
>  > seems that isn't a problem? "I dont know"
>  > But if you're like me  "maticulous"; things like that will bug me all day long.
>  > besides that, are you receiving any freezes at all?, I'm unable to use
>  > that kernel due to the freezes that it's giving me.?
>  > regards;
>  >
>
>  The kernel seems to work fine I don't have any kind freezes or crashes on that box.
>
>  Gabriel
>

Cool, kernel-2.6.25-rc9 is where I'm at, everything is working fine,
as for the freezeing I'm experiencing, If somebody else reports the
same as well With the same hardware as what I'm using, then buggzilla,
but until then I'm going to look at my .config

-- 
Justin P. Mattock
