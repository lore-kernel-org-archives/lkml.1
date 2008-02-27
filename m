Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbYB0WxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbYB0WxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbYB0Wwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:52:55 -0500
Received: from spiffy.freedom.ind.br ([201.35.65.91]:49730 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752867AbYB0Wwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:52:54 -0500
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: oops when using git gc --auto
References: <87tzjvhmy7.fsf@ossystems.com.br>
	<200802270033.31297.nickpiggin@yahoo.com.au>
	<87zltnjys1.fsf@ossystems.com.br>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Wed, 27 Feb 2008 17:01:17 -0300
In-Reply-To: <87zltnjys1.fsf@ossystems.com.br> (Otavio Salvador's message of "Tue\, 26 Feb 2008 16\:36\:14 -0300")
Message-ID: <877igqdv8y.fsf@ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otavio Salvador <otavio@debian.org> writes:

> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>
>> On Wednesday 27 February 2008 00:22, Otavio Salvador wrote:
>>> Hello,
>>>
>>> Today I got this oops, someone has an idea of what's going wrong?
>>>
>>> Unable to handle kernel paging request at 0000020000000000 RIP:
>>>  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
>>
>> At this point, the most likely candidate is a memory corruption
>> error, probably hardware. Can you run memtest86 for a few hours
>> to get a bit more confidence in the hw (preferably overnight)?
>>
>> I did recently see another quite similar corruption in the
>> pagecache radix-tree, though. Coincidence maybe?
>
> I let it running at lunch time and all went OK. I've also let burnP6
> running later and nothing happened. Looks like hw is OK.
>
> I've just got another oops, with same kernel.
>
> Unable to handle kernel paging request at ffff83006d922370 RIP: 
>  [<ffffffff8027a79b>] shrink_page_list+0x16f/0x570

In the end, it was a motherboard issue.

Thanks for the help!

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
