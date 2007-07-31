Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbXGaMeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbXGaMeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXGaMd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:33:56 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:55502 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbXGaMdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:33:55 -0400
Message-ID: <46AF2BF8.3000601@free.fr>
Date: Tue, 31 Jul 2007 14:32:56 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: BIOS implementors disabling the LAPIC
References: <46AEED9E.1050904@free.fr> <Pine.LNX.4.64N.0707311119350.16158@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0707311119350.16158@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:

> John Sigler wrote:
> 
>> As far as I understand, the Local APIC was integrated directly to the CPU
>> 12-15 years ago. Why would a BIOS implementor choose to disable it?
> 
> Because they are lazy/incapable/out-of-time/select-your-favourite-excuse.
> For the chip to work you have to provide some minimal support in the
> firmware, in particular for the trickier paths of execution in the system
> management mode.  The system still works with the Local APIC disabled, so
> why bother?

The motherboard manufacturer (well, their level 1 support, anyway) told 
me I could "safely enable the LAPIC". If it is safe to enable the LAPIC, 
then why are they disabling it in the BIOS? (They weren't able to tell 
me whether their BIOS triggers SMIs or not...)

Is this a "either works or doesn't" situation where hell should break 
loose if I try to enable the LAPIC and it's not supported by the 
motherboard, or is this a "you will silently lose data at the worst 
possible time" situation?

>> (And what does it mean to "disable" the LAPIC?)
> 
> The LINT0 and LINT1 inputs of the APIC are routed straight to the INT and
> NMI inputs of the CPU respectively and the rest of the APIC logic becomes
> inactive (tri-stated, etc.).

If that were the case, then I could not enable the LAPIC and have NMIs 
work, right?

Regards.
