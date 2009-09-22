Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZIVV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZIVV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZIVV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:29:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZIVV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:29:35 -0400
Message-ID: <4AB9414C.6060805@zytor.com>
Date: Tue, 22 Sep 2009 14:27:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	 <20090919224430.GB9567@kroah.com>	 <1253419185.3253.21.camel@ank32.eng.vmware.com>	 <20090920074247.GA5733@elte.hu> <1253647845.10565.20.camel@ank32.eng.vmware.com>
In-Reply-To: <1253647845.10565.20.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Ingo,
> 
> On Sun, 2009-09-20 at 00:42 -0700, Ingo Molnar wrote:
> 
>> The thing is, the overwhelming majority of vmware users dont benefit 
>> from hardware features like nested page tables yet. So this needs to be 
>> done _way_ more carefully, with a proper sunset period of a couple of 
>> kernel cycles.
> 
> I am fine with that too. Below is a patch which adds notes in
> feature-removal-schedule.txt, I have marked it for removal from 2.6.34.
> Please consider this patch for 2.6.32.
> 

This seems way, way too early still.

	-hpa
