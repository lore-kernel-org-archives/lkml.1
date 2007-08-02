Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbXHBLc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbXHBLc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXHBLcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:32:21 -0400
Received: from mailout07.sul.t-online.de ([194.25.134.83]:35544 "EHLO
	mailout07.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbXHBLcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:32:20 -0400
Message-ID: <46B1C0BA.1020004@t-online.de>
Date: Thu, 02 Aug 2007 13:32:10 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, pavel@ucw.cz,
       mjg59@srcf.ucam.org, lenb@kernel.org,
       =?UTF-8?B?QWRyaWFu?= =?UTF-8?B?IFNjaHLDtnRlcg==?= 
	<adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22 regression: thermal trip points
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de>
In-Reply-To: <1186047747.18821.450.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ID: Go6cCiZDweIP7QjoNHuEwojBNBvJ7GbSq+ShumNe1s+Nc2iPd3TvsC
X-TOI-MSGID: fe3e96fa-414e-4842-a20b-8a6100c700de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
>> mainboard: AOpen i915GMm-hfs, AWARD BIOS
>> cpu: Pentium-M 750 (0.8 to 1.86 MHz)
>> openSuSE 10.2 with kernel 2.6.22.1
> Is this a DELL laptop that gets throttled by 75% to throttling state 6
> if 60 degrees are exceeded?
No, it is a Pentium M desktop board.:
    Chipset i915GM, FSB 533MHz, max 2GB DDR2 RAM, 2 PCI
    and 1 16x PCI Express slots, serial, parallel, usb, firewire,
    2x Marvel Gigabit Ethernet, Realtek ALC 880 sound, IDE,
    Intel SATA and SiI SATA Raid, FDC, DVI and VGA video out etc.
    Very low power consumption: ~40W to 65W for the whole system,
    except monitor.
> As 2.6.22 was shipped without, I think reverting is not a real option.
Well, it would not be the first time to eliminate a regression by
reverting a
patch after it was accepted previously.
>> Sanity checks that trip points only can get lowered (compared to initial
>> provided ones) needs to be added.
>> Len, Rui: For short-term can some 
But I _need_ to raise the unreasonably low passive trip point. We could
decide to
protect the innocent user by allowing write access to trip_points only
after a previous

echo "I know what I am doing" >
/proc/acpi/thermal_zone/THRM/enable_really_dangerous_options

if we believe that this is a good idea ...

Andi Kleen wrote:

  > I don't think it's that unreasonable to require source code
modifications
  >  for anything that can kill hardware. At least that raises the barrier
  >  a bit and hopefully ensures people think twice about it and then really
  > only blame themselves if anything goes wrong.

Andi, would the above be mechanism sufficiently safe for your taste?

cu,
 Knut

