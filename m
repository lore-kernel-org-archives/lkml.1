Return-Path: <linux-kernel-owner+w=401wt.eu-S1753572AbZKNHUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbZKNHUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 02:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZKNHUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 02:20:22 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:21280 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752800AbZKNHUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 02:20:21 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xTsRGDMVM1nLgraYvuCVP1OCvRIiU.JpGd_Yr0wW4.der3KMebnyDuhQ5RwlMeSToSHyXsbDLxHlYDQ4LwAw_6XQ9vG6Zek3qSk0EPLGn0TFspSiepLX7QmVIUi2UvS0HpATOyVmdgt4oAOk._yJo4Dxnvr6YaLimXhQ4DnsJ3.EfofKk1H2U4gSvFcbkL_GqmxDJ7kqMBcChMX.Zvow_t1yqzUnRfAfAq.Vm.fwwRly8q.DbP1VobWRwuk3d6PB41YbO9QtgK0_ETR2gwOmN7XNAVzfFYc0VzNlIvZsylRGcZQguEBsDB9.bt8lrZbuFWHvkzui.hBkluyvLKk-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AFE5A20.20608@schaufler-ca.com>
Date: Fri, 13 Nov 2009 23:20:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Wagner <daw-news@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>	 <4AFCC06B.1030302@schaufler-ca.com>	 <19857.1258147396@turing-police.cc.vt.edu>	 <4AFE1EA9.60102@schaufler-ca.com>  <hdl92e$srv$1@taverner.cs.berkeley.edu>	 <1258170491.16857.142.camel@Joe-Laptop.home>	 <4AFE3C53.70709@schaufler-ca.com> <1258176381.16857.155.camel@Joe-Laptop.home>
In-Reply-To: <1258176381.16857.155.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Fri, 2009-11-13 at 21:12 -0800, Casey Schaufler wrote: 
>   
>> Joe Perches wrote:
>>     
>>> On Sat, 2009-11-14 at 03:44 +0000, David Wagner wrote:
>>>       
>>>> I personally don't find
>>>>     strncmp(foo, "constant", sizeof("constant"))        // first snippet
>>>> to be more readable, auditable, or obviously correct than
>>>>     strcmp(foo, "constant").                            // second snippet
>>>> Is there a technical basis for arguing that the first
>>>> snippet is better than the second snippet?
>>>>         
>>> I don't think there is.
>>>       
>> And you're exactly correct.
>> This whole discussion is around a gratuitous
>> change that has no net effect on the behavior of the system.
>>     
>
> It has relatively little or no effect on a
> running system, but does effect code
> readability.
>
>   
>> I am advocating that the code be left as is.
>>     
>
> I assert that code should be made as readable
> as possible and that the code used fit the
> reader's expectations.
>
> strcmp(foo, "BAR") is natural.
> strncmp(foo, "BAR", sizeof("BAR")) is unnatural
> and should not be used.
>
>   

Oh good gravy. I've been writing C code since the 1970's and
have seen enough "unnatural" code to make most people think that
PASCAL was a good idea. This is not unnatural code. This is an
argument over which side of the head of the pin the odd angel
should dance on. Give it up. You're advocating a gratuitous
change. Can't y'all go find some questionable casts to expunge?
That might actually be useful.

> cheers, Joe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

