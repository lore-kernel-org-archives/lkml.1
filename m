Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXBXNkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXBXNkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932797AbXBXNkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:40:09 -0500
Received: from [194.112.174.227] ([194.112.174.227]:37909 "EHLO mail.hofr.at"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXBXNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:40:08 -0500
Date: Sat, 24 Feb 2007 13:56:25 +0100 (CET)
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Nicholas Mc Guire <der.herr@hofr.at>, linux-kernel@vger.kernel.org
Subject: Re: typo in include/linux/irqflags.h ?
In-Reply-To: <20070224131422.GA5047@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.60.0702241354120.1821@rtl14.hofr.at>
References: <Pine.LNX.4.60.0702241243270.1583@rtl14.hofr.at>
 <20070224131422.GA5047@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

> On Sat, Feb 24, 2007 at 12:45:16PM +0100, Nicholas Mc Guire wrote:
>>
>> Hi !
>>
>> Seems like there was a cut&past error in include/linux/riqflags.h.
>>
>>
>> --- linux-2.6.20/include/linux/irqflags.h	2007-02-04 09:44:54.000000000 -0900
>> +++ linux-2.6.20xm/include/linux/irqflags.h	2008-01-27 20:29:26.000000000 -0900
>> @@ -91,6 +91,6 @@
>>   })
>>
>>   #define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
>> -#endif		/* CONFIG_X86 */
>> +#endif		/* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>
> Just yet rid of the comment - you can see the corresponding #ifdef on
> the screen without paging up or down so it seems pointless to have such
> a comment - it just adds additional unnecessary clutter to the screen.
>
well not for people that only have one line on the braille-screen,
for it helps but it better be right or we get lost completly ;)

hofrat
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFF4DX6nU7rXZKfY2oRAg6zAJ4kK0c6T+fEXavRELt5vJnpLQxbYACfQhvR
bWg4oR0/6ng+1Cmlzwn7Igc=
=hQd0
-----END PGP SIGNATURE-----
