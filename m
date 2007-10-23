Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXJWWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXJWWQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJWWQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:16:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXJWWQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:16:11 -0400
Message-ID: <471E729F.3000105@zytor.com>
Date: Tue, 23 Oct 2007 15:15:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v7 1/3] x86 boot: setup data
References: <1193126771.23935.79.camel@caritas-dev.intel.com> <471E70E0.2090802@goop.org>
In-Reply-To: <471E70E0.2090802@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>  1:
>> +	movl boot_params - __PAGE_OFFSET + SETUP_DATA_POINTER,%ebp
> 
> You need to check the boot protocol version before looking at this pointer.
> 

No, he doesn't.  The boot protocol version is communication between the 
boot loader and the kernel (specifically, it is communication FROM the 
kernel TO the bootloader), not between internal bits of the kernel.  Th

Since the pointer is safely inside the setup template, even if the 
bootloader doesn't understand boot protocol version 2.08 it will have 
copied it.

So this is fine.

	-hpa
