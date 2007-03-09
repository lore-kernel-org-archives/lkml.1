Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbXCIAW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbXCIAW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXCIAW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:22:28 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:34614 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbXCIAW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:22:26 -0500
Subject: Re: hardwired VMI crap
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F0A254.4020002@vmware.com>
References: <45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>
	 <45EFE010.7080108@vmware.com>
	 <1173352154.24738.1023.camel@localhost.localdomain>
	 <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org>
	 <20070308213458.GA24634@elte.hu> <45F09EAE.6090908@goop.org>
	 <45F0A254.4020002@vmware.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 16:22:23 -0800
Message-Id: <1173399743.20300.3.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 15:55 -0800, Zachary Amsden wrote:

> 
> We just don't drive the local timer interrupts through the APIC, we make 
> hypercalls to schedule local timer alarms.  Which is something we must 
> do for UP kernels as well, which use the PIT / PIC.  So there is a need 
> for having clockevents code which doesn't program timers through the APIC.

This getting a bit confusing to me .. When your talking about "local
timer interrupts" are you speaking of a periodic interrupt from the
lapic , or the jiffies increment inside the virtual machine?

Daniel

