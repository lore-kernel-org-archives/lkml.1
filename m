Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYBREIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYBREIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYBREIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:08:25 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:17290 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbYBREIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:08:24 -0500
Message-ID: <47B90501.3080307@larces.uece.br>
Date: Mon, 18 Feb 2008 01:09:37 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: What is "ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko]
 undefined!"
References: <47B786BF.8050703@gmail.com>	 <20080216202740.74e22dbb.randy.dunlap@oracle.com>	 <804dabb00802171638t30a4e754t53781a8f76fe5c22@mail.gmail.com>	 <47B8DB7F.7070206@larces.uece.br> <804dabb00802171927r472fe558wfd44a5aa9da9381d@mail.gmail.com>
In-Reply-To: <804dabb00802171927r472fe558wfd44a5aa9da9381d@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> On 2/18/08, Sergio Luis <sergio@larces.uece.br> wrote:
>> Peter Teoh wrote:
>>> On 2/17/08, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> On Sun, 17 Feb 2008 08:58:39 +0800 Peter Teoh wrote:
>>>>
>>>>> Can some explain the cause of this error (it has been like this for the
>>>>> last two git pull from linus tree):
>>>>>
>>>>> Kernel: arch/x86/boot/bzImage is ready  (#1)
>>>>>   Building modules, stage 2.
>>>>>   MODPOST 1589 modules
>>>>> ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
>>>>> ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!
>>>>> WARNING: modpost: Found 14 section mismatch(es).
>>>>> To see full details build your kernel with:
>>>>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>>>> make[1]: *** [__modpost] Error 1
>>>>> make: *** [modules] Error 2
>>>> Please try the patch at
>>>> http://marc.info/?l=linux-kernel&m=120206956919303&w=2
>>>> and report on its success/failure.  Thanks.
>>>>
>>>> ---
>>>> ~Randy
>>>>
>>> sorry for the delay....the problem still comes back after the patch...any ideas?
>>>
>>> THanks.
>> you could test the patch I just posted at http://lkml.org/lkml/2008/2/17/388
>> rusty's patch needs to be applied first.
>> -sergio
>>
>>> --
> Good, after the two patch applied the compilation was successful.
> Thank you very much!!!

just a note. remember try out the 2nd patch I sent a few min after the 1st one, please. I forgot something in the 1st version and reposted it updated.
you can find it there http://lkml.org/lkml/2008/2/17/395
thanks,
-sergio.
