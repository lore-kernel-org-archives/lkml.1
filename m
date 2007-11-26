Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXKZWIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXKZWIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbXKZWIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:08:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:6019 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbXKZWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IyWMAYXaAEvAsmd5VXs1iClx7acWkGV6XLQHDY9eIHOOgzqMbzfaJ4cJxLyTnv9UiT1hQdOkR2AV1l/PzK32w5qeNMZFGpHbG3/HJ2i+SlbYQP+HA0ndyQ+ORalG3AT4GhwRy1n9OyflIXmmZH4HYCpW1fjU0EUN1BHPXWNKQjo=
Message-ID: <474B43E1.9080407@gmail.com>
Date: Mon, 26 Nov 2007 23:08:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org> <20071126143943.0a01665b@cuia.boston.redhat.com> <20071126123319.7483e57f.akpm@linux-foundation.org> <20071126204540.GA19874@elte.hu>
In-Reply-To: <20071126204540.GA19874@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2007 09:45 PM, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Mon, 26 Nov 2007 14:39:43 -0500
>> Rik van Riel <riel@redhat.com> wrote:
>>
>>> On Tue, 20 Nov 2007 22:18:39 -0800
>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>>> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>>> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
>>>> ACPI or x86 breakage, I guess.
>>>>
>>>> Did 'noapic' work?
>>> I got the same bug as above, 'noapic' gets past that point 
>> We still don't know what caused this, afaik.
> 
> yes. Is it a regression? If yes, could someone try to bisect it so that 
> we can fix it? If it's caused by x86.git then the 'mm' branch of the x86 
> git tree can be used for bisection:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

I did, but it's hard, if you don't know the BAD point. HEAD boots fine and 'x86:
randomize brk' too (the top of git-x86.patch). Andrew, how do you pull it, git
#mm doesn't fit to the ids from the patch.

Maybe if you can emit a broken-out with the fresh pull to test?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
