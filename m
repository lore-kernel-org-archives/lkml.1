Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXI0Vql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXI0Vql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbXI0Vqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:46:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408AbXI0Vqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:46:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Problems with SMP & ACPI powering off
Date: Fri, 28 Sep 2007 00:00:52 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, simon.derr@bull.net,
       Len Brown <lenb@kernel.org>
References: <46FC20B7.4000606@rtr.ca>
In-Reply-To: <46FC20B7.4000606@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709280000.53001.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 September 2007 23:29, Mark Lord wrote:
> Question:  do we disable all CPUs except 0 when doing ACPI power off?

No, but we should.

> Background:
> I have a machine here dedicated to running MythTV.
> It powers up to record, and then sets the RTC alarm for next time
> and powers down again in between recordings.
> 
> It has an Intel Core2duo E6300 CPU, currently on an ICH8 motherboard.
> Previously it was on a completely different (vendor,bios,...) ICH7 motherboard.
> 
> In both cases, "halt -p" sometimes fails to actually turn off the power,
> which means that it later then fails to "turn on" to record again.
> 
> Annoying.
> 
> This is a 32-bit kernel/runtime, with full ACPI (not APM) kernel support enabled.
> 
> So I'm wondering if it may be due to the old SMP-poweroff bogeyman ?

May be.

Which kernel?

> For now, I've hardcoded a cpu_down(1) into the poweroff code,
> and we'll see if that helps or is merely redundant.
> 
> But I do wonder where else to look for a cause?
> 
> Two different boards, vendors, BIOSs, same CPU chip.  Same problem.

Same chipset, perchance?

Greetings,
Rafael
