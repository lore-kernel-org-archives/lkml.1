Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbYBQBXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbYBQBXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 20:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYBQBXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 20:23:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43282 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYBQBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 20:23:37 -0500
Message-ID: <47B78C6C.6040905@zytor.com>
Date: Sat, 16 Feb 2008 17:22:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
Subject: Re: 2.6.25-rc2-mm1 (wakeup)
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216094844.3e5224f0.randy.dunlap@oracle.com> <200802170218.08770.rjw@sisk.pl>
In-Reply-To: <200802170218.08770.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 16 of February 2008, Randy Dunlap wrote:
>> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
>> The ACPI wakeup in C patch (I think) won't build for me on x86_32
>> (i.e., i386 build on x86_64 system):
>>
>> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
>> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: CPU you selected does not support x86-64 instruction set
>> linux-2.6.25-rc2-mm1/arch/x86/kernel/acpi/realmode/wakeup.S:0: error: -mpreferred-stack-boundary=2 is not between 4 and 12
>> make[4]: *** [arch/x86/kernel/acpi/realmode/wakeup.o] Error 1
>> make[3]: *** [arch/x86/kernel/acpi/realmode/wakeup.bin] Error 2
> 
> It compiles for me on a native i386.
> 
> Can you please give me a hint what to do to reproduce the problem?

Sounds like you're not adding -m32 to the gcc command line.

	-hpa
