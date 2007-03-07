Return-Path: <linux-kernel-owner+w=401wt.eu-S2992563AbXCGUyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992563AbXCGUyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992564AbXCGUyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:54:04 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34418 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992563AbXCGUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:54:01 -0500
Message-ID: <45EF2560.7090104@vmware.com>
Date: Wed, 07 Mar 2007 12:49:36 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: James Morris <jmorris@namei.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	<45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	<20070306084647.GA16280@elte.hu> <45ED2C82.3080008@vmware.com>	<1173178774.24738.311.camel@localhost.localdomain>	<45EDD82F.90204@vmware.com>	<1173225182.24738.507.camel@localhost.localdomain>	<45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>	<1173228544.24738.514.camel@localhost.localdomain>	<45EE0D10.7070807@vmware.com>	<1173230305.24738.529.camel@localhost.localdomain>	<45EE1EA3.90803@vmware.com>	<1173256666.24738.576.camel@localhost.localdomain>	<45EEF966.6060902@goop.org>	<Line.LNX.4.64.0703071304080.1851@d.namei> <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <45EF1C80.50900@goop.org>
In-Reply-To: <45EF1C80.50900@goop.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 20:53:59.0943 (UTC) FILETIME=[BB09F170:01C760FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 12:11 PM, Jeremy Fitzhardinge wrote:
> Dan Hecht wrote:
>> Jeremy, I saw you sent out the Xen version earlier, thanks.  Here's
>> ours for reference (please excuse any formating issues); it's also
>> lean. We'll send out a proper patch later after some more testing:
> 
> So the interrupt side of the clockevent comes through the virtual apic? 
> Where does evt->handle_event get called?
> 

Yeah, we use the same interrupt handlers as normal i386: timer_interrupt 
and smp_apic_timer_interrupt.  That way we don't need to duplicate the 
interrupt handler code.
