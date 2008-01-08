Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbYAHQke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbYAHQke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbYAHQkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:40:21 -0500
Received: from stinky.trash.net ([213.144.137.162]:64200 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbYAHQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:40:19 -0500
Message-ID: <4783A685.7070109@trash.net>
Date: Tue, 08 Jan 2008 17:36:21 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] ip[6]_tables.c: remove some inlines
References: <200712161247.53986.vda.linux@googlemail.com> <200712311643.41946.vda.linux@googlemail.com> <47792032.3020609@trash.net> <200712311755.02578.vda.linux@googlemail.com>
In-Reply-To: <200712311755.02578.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Monday 31 December 2007 17:00, Patrick McHardy wrote:
>> Denys Vlasenko wrote:
>>> ip[6]_tables.c seem to abuse inline.
>>>
>>> This patch removes inlines except those which are used
>>> by packet matching code and thus are performance-critical.
>>>   
>> Some people also consider the ruleset replacement path performance
>> critical, but overall I agree with your patch. I'm travelling currently
>> though so it will take a few days until I'll apply it.
>>
>> Do you have some numbers that show the actual difference these
>> changes make?
> 
> Before:
> 
> $ size */*/*/ip*tables*.o
>    text    data     bss     dec     hex filename
>    6402     500      16    6918    1b06 net/ipv4/netfilter/ip_tables.o
>    7130     500      16    7646    1dde net/ipv6/netfilter/ip6_tables.o
> 
> After:
> 
> $ size */*/*/ip*tables*.o
>    text    data     bss     dec     hex filename
>    6307     500      16    6823    1aa7 net/ipv4/netfilter/ip_tables.o
>    7010     500      16    7526    1d66 net/ipv6/netfilter/ip6_tables.o


Applied, thanks.
