Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbXI0WDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbXI0WDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXI0WDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:03:09 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:46554 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044AbXI0WDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:03:08 -0400
Message-ID: <46FC28A4.9080008@cfl.rr.com>
Date: Thu, 27 Sep 2007 18:03:16 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <20070915003906.5fa6dc0f.akpm@linux-foundation.org> <200709151258.28745.ioe-lkml@rameria.de> <20070915040802.bb3c7093.akpm@linux-foundation.org> <20070915120824.GA21243@srcf.ucam.org> <20070924213224.GI8127@redhat.com>
In-Reply-To: <20070924213224.GI8127@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2007 22:03:23.0018 (UTC) FILETIME=[38B1C6A0:01C80152]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15450.001
X-TM-AS-Result: No--14.276000-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> If memory serves correctly, that was circa 2.6.10, back in these commits..
> 
> commit a068ea13d1db406e15c346e93530343f6e70184c
> Author: Len Brown <len.brown@intel.com>
> Date:   Sun Oct 10 05:21:08 2004 -0400
> 
>     [ACPI] If BIOS disabled the LAPIC, believe it by default.
>     "lapic" is available to force enabling the LAPIC
>     in the event you know more than your BIOS vendor.
>     http://bugzilla.kernel.org/show_bug.cgi?id=3238
> 
> commit 2fcfece90db9643b6f30a7ad343898a2871e6a81
> Author: Len Brown <len.brown@intel.com>
> Date:   Sat Oct 9 20:12:45 2004 -0400
> 
>     [ACPI] Don't enable LAPIC when the BIOS disabled it.
>     Doing so apparently breaks every Dell on Earth.
>     http://bugzilla.kernel.org/show_bug.cgi?id=3238
> 
> 
> But those changes relate to the local APIC, which 'noapic' shouldn't
> have any effect on should it ?

If the LAPIC is disabled, then you CAN'T use the IO-APIC right?  So then
wouldn't the noapic option have no effects since the apic is already
disabled?



