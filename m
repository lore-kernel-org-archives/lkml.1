Return-Path: <linux-kernel-owner+w=401wt.eu-S1945951AbXBIBVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951AbXBIBVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945986AbXBIBVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:21:22 -0500
Received: from terminus.zytor.com ([192.83.249.54]:43095 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951AbXBIBVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:21:21 -0500
Message-ID: <45CBCC72.6080409@zytor.com>
Date: Thu, 08 Feb 2007 17:20:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Brown <neilb@suse.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Use correct macros in raid code, not raw asm
References: <1167348861.30506.46.camel@localhost.localdomain> <20061228155659.462eaa9c.akpm@osdl.org> <1167350803.30506.49.camel@localhost.localdomain> <20061229111355.GA82929@muc.de>
In-Reply-To: <20061229111355.GA82929@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The code looks like it's designed to be included from userspace for
>> testing; as it compiles without this include (and has no other
>> includes), I chose not to add it.
>>
>> Linus makes a good point, but someone who actually knows the code
>> should, y'know, test it and stuff...
> 
> It should use kernel_fpu_begin() imho. If someone wants to test
> it in user space again they can add dummy definitions of that
> to their user space  header.

I hadn't seen this thread until now, when Neil pointed me to the thread.

Using kernel_fpu_begin() ... kernel_fpu_end() is probably indeed the 
best option.

	-hpa

