Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbYD0WOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbYD0WOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYD0WOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:14:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYD0WOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:14:16 -0400
Message-ID: <4814FAA0.8060705@zytor.com>
Date: Sun, 27 Apr 2008 15:13:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breakage caused by unreviewed patch in x86 tree
References: <1209329485.3801.46.camel@localhost.localdomain>	 <4814F76B.8030505@zytor.com> <1209334212.3801.70.camel@localhost.localdomain>
In-Reply-To: <1209334212.3801.70.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Sun, 2008-04-27 at 15:00 -0700, H. Peter Anvin wrote:
>> James Bottomley wrote:
>>> I might add that the intel SAPIC functions
>>> in roughly the same manner, so this might break more than just voyager.
>> Are you referring to the IA64 SAPIC here, or something else?  The only 
>> mention of SAPIC in the x86 tree appear to be naming of fields in ACPI 
>> tables.
> 
> Yes, that's the one ... but I believe a class of the xAPICs also used a
> similar principle.

I certainly have never seen a system on which the APIC has been mapped 
cacheable.  I would be very interested in the details, so if you could 
elaborate that would be extremely useful.

	-hpa

