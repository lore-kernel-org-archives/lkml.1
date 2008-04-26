Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbYDZQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbYDZQGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYDZQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:06:11 -0400
Received: from [83.228.35.12] ([83.228.35.12]:49217 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbYDZQGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:06:10 -0400
References: <200804250028.24913.pvp@fs.ru.acad.bg>
            <481173E7.3050903@fs.ru.acad.bg>
            <20080424.233521.111619900.davem@davemloft.net>
            <200804252020.50178.IvDoorn@gmail.com>
In-Reply-To: <200804252020.50178.IvDoorn@gmail.com>
From: plamen.petrov@tk.ru.acad.bg
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: latest git (linux-2.6.25-git6) compile error
Date: Sat, 26 Apr 2008 19:06:06 +0300
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Message-ID: <courier.481352EE.000074D4@fs.ru.acad.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo van Doorn написа: 

> On Friday 25 April 2008, David Miller wrote:
>> From: Plamen Petrov <plamen.petrov@fs.ru.acad.bg>
>> Date: Fri, 25 Apr 2008 09:02:15 +0300 
>> 
>> > Ivo van Doorn wrote:
>> > > Can you confirm that this error goes away when enabling CONFIG_NEW_LEDS ?

Yes, the error goes away when I enable CONFIG_NEW_LEDS. I used 2.6.25-git7, 
though. 

>> > >
>> > > Ivo
>> > >   
>> > Will try and report later - now I'm at work, away from the machine. 
>> 
>> This should have been fixed by the patch below. 
>> 
>> Or is it the problem that simply selecting LEDS_CLASS doesn't take
>> care of LEDS_CLASS's dependencies such as NEW_LEDS?  Ugh, if so...
> 
> The config file from Plamen contains:
> # CONFIG_NEW_LEDS is not set
> CONFIG_LEDS_CLASS=y 
> 
> So this is a dependency problem, I guess the functions:
> led_classdev_resume
> led_classdev_suspend
> led_classdev_register
> led_classdev_unregister
> are only compiled in when NED_LEDS is selected. :S 
> 
 


-- 
Plamen Petrov, network & system administrator
Filial - Silistra
RU "Angel Kantchev"
http://fs.ru.acad.bg/
 --------------------------------
this message is UTF8 encoded 

_
___
_____
 ------------------------------------------
This message was sent by the mail server
at fs.ru.acad.bg using the web interface:
    https://fs.ru.acad.bg/s/m/webmail
E-mail postmaster@fs.ru.acad.bg with anything,
regarding the server itself
