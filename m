Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbXFJAIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbXFJAIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 20:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXFJAIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 20:08:00 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44392
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbXFJAH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 20:07:58 -0400
Date: Sat, 9 Jun 2007 17:06:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Crispin Cowan <crispin@novell.com>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: AppArmor FAQ
In-Reply-To: <20070609230239.GA21229@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706091702280.6675@asgard.lang.hm>
References: <20070417181016.GA10903@one.firstfloor.org>
 <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org>
 <20070417225815.000b0fdb@the-village.bc.nu> <Line.LNX.4.64.0704180935100.25495@d.namei>
 <4626746A.9010701@novell.com> <20070609210151.GB6663@elf.ucw.cz>
 <Pine.LNX.4.64.0706091426240.6313@asgard.lang.hm> <20070609230239.GA21229@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Pavel Machek wrote:

>>>>>> I'm not sure if AppArmor can be made good security for the general case,
>>>>>> but it is a model that works in the limited http environment
>>>>>> (eg .htaccess) and is something people can play with and hack on and may
>>>>>> be possible to configure to be very secure.
>>>>>>
>>>>> Perhaps -- until your httpd is compromised via a buffer overflow or
>>>>> simply misbehaves due to a software or configuration flaw, then the
>>>>> assumptions being made about its use of pathnames and their security
>>>>> properties are out the window.
>>>>>
>>>> How is it that you think a buffer overflow in httpd could allow an
>>>> attacker to break out of an AppArmor profile? This is exactly what
>>>> AppArmor was designed to do, and without specifics, this is just
>>>> FUD.
>>>
>>> No, it is not, I already broke AppArmor once, and it took me less then
>>> one hour.
>>>
>>> Give me machine with root shell, and make app armor permit everything
>>> but reading /etc/secret.file. AppArmor is not designed for this, but
>>> if you want to claim your solution works, this looks like a nice test.
>>>
>>> Actually, give password to everyone, and see who breaks it first.
>>
>> you admit that AA isn't designed for this and then you set this as the
>> test, doesn't that seem unreasonable to you?
>
> httpd's run at root priviledge, AFAICT, and Crispin just accused
> someone of spreading fud. Exploited httpd is root shell.

only poorly designed webservers run as root. in general they have not been 
running as root for many years.

however, if you are willing to take a limited shell (root or any other 
user) that's a different story, what would you want the shell to have 
permission to do? would read files in directory A and write files in 
directory B be good enough? or would you want it to be able to execute 
specific commands?

note that at the moment I am not comitting anyone to provide a box for 
such a challange, but I'm interested in what you would consider a suitable 
test.

David Lang
