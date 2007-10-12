Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbXJLL6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbXJLL6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 07:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbXJLL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 07:58:37 -0400
Received: from m-04.th.seeweb.it ([217.64.195.227]:35748 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbXJLL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 07:58:36 -0400
Message-ID: <470F600B.3030305@users.sourceforge.net>
Date: Fri, 12 Oct 2007 13:52:43 +0200
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Laptop keyboard unusable when ACPI is active
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net>
In-Reply-To: <470DD906.9090504@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am posting this message just to say that this bug is being addressed
on the bug tracker:
http://bugzilla.kernel.org/show_bug.cgi?id=9147

Regards,
--
  Daniele C.


legolas558@users.sourceforge.net ha scritto:
> legolas558@users.sourceforge.net ha scritto:
>   
>> Kernel: 2.6.22-r5
>> Kernel option: i8042.nomux=1
>>     
> I am now using kernel 2.6.22-r8 (Gentoo) and the following kernel options:
>
> i8042.nomux=1 acpi=off
>
> I have tried kernel 2.6.23-rc9 but the problem is still there.
>
>   
>> The problem which still remains, and I can't fix or work it around, is
>> witnessed by the below dmesg lines:
>> -----
>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>> isa0060/serio0).
>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>> isa0060/serio0).
>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>> isa0060/serio0).
>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>> -----
>> The release event for some keys is never caught, so all sorts of
>> troubles happen if for example I use the Del key and it stucks, or if
>> I use the Ctrl key and it never gets released...pushing again the
>> stuck key brings back the key in the proper status.
>>     
> With acpi=off the problem is totally worked around.
>
>   
>> Can somebody please give me some clues about this issue, and possible
>> solutions? I have been searching the web for a couple of weeks and
>> seems like it is a common trouble of notebook users, but nobody has
>> yet published a solution.
>>     
> I am trying to find a path myself in this issue - which dates back to at
> least 2005 and has never been resolved.
>
> I would now try some other kernel parameter in order to preserve ACPI
> functionality and possibly prevent ACPI from messing up the keyboard IRQs.
> Can somebody please give me istructions regarding the correct tests
> (regarding kernel parameters and/or anything else) to perform in order
> to better isolate the issue?
>
> Related Gentoo bug tracker item:
> http://bugs.gentoo.org/show_bug.cgi?id=194781
>
> Other messages about the same kernel bug (many more can be found
> googling around, and no solution yet):
> https://lists.linux-foundation.org/pipermail/bugme-new/2005-January/011736.html
> http://dev.laptop.org/ticket/2401
>
> Regards,
> --
>   Daniele C.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

