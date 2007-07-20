Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXGTGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXGTGtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXGTGtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:49:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45180 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbXGTGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:49:13 -0400
Message-ID: <46A051EE.7060304@vmware.com>
Date: Thu, 19 Jul 2007 23:10:54 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@qumranet.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under	arch-level
 Virtualization option
References: <1184905342.10380.263.camel@localhost.localdomain>	 <46A046F1.7040207@qumranet.com> <1184911347.10380.274.camel@localhost.localdomain>
In-Reply-To: <1184911347.10380.274.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> Otherwise we end up with $NARCH copies of that Kconfig, each slightly
>> different.  The top-level entry can be made to depend on the archs that
>> actually have some virt capability, so as not to show empty an menu.
>>     
>
> I dislike the duplication, too, but 
>
> 1) it's a CPU capability, and that's where it belongs in the menu.
> 2) And as you can see from the difference between the x86_64 and i386
> help text, there are real platform differences (and not mentioning
> what's under the menu would be kinda cheating).
> 3) Virtualization doesn't even make sense as an option for some
> platforms where it's always on.
>   

I'm rather indifferent on the matter, but I think a virtualization menu 
under UML would be very confusing.

Zach
