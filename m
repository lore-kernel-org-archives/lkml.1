Return-Path: <linux-kernel-owner+w=401wt.eu-S1763968AbXEZUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763968AbXEZUnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759552AbXEZUnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:43:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbXEZUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:43:12 -0400
Message-ID: <46589BCD.4040807@zytor.com>
Date: Sat, 26 May 2007 13:42:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Extending boot protocol & bzImage for paravirt_ops
References: <4656FB8F.4090604@goop.org>	 <m14pm0c0m2.fsf@ebiederm.dsl.xmission.com> <1180174691.650.8.camel@localhost.localdomain>
In-Reply-To: <1180174691.650.8.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>>
>> +  Bit 6 (write): KEEP_SEGMENTS
>> +	Protocol: 2.07+
>> +	- if 0, reload the segment registers in the 32bit entry point.
>> +	- if 1, do not reload the segment registers in the 32bit entry point.
>> +		Assume that %cs %ds %ss %es are all set to flat segments with
>> +		a base of 0 (or the equivalent for their environment).
> 
> You also want to skip the cli: perhaps a separate flag for this is
> appropriate though.
> 

Do we have *any* environment that enters the 32-bit code with interrupts
enabled?  I would think that is unsafe no matter how you do it.

	-hpa
