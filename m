Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZDNMRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZDNMRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZDNMQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:16:49 -0400
Received: from stinky.trash.net ([213.144.137.162]:61757 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZDNMQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:16:48 -0400
Message-ID: <49E47EA5.3060706@trash.net>
Date: Tue, 14 Apr 2009 14:16:37 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: panic on rmmod of nf_conntrack_irc
References: <20090410191736.21efab8c@mako-desktop> <49E4744D.5090205@trash.net> <49E47C2D.1050508@cosmosbay.com>
In-Reply-To: <49E47C2D.1050508@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Patrick McHardy a écrit :
>> Mariusz Kozlowski wrote:
>>>     netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of
>>> call_rcu()
>> Thanks for the report. Does this patch fix it?
>>
> 
> Hi Patrick, sorry for the delay, I was in holidays.

No problem, me too :)

> I should have used different fields names (from "next", "first", ...) to catch this
> kind of errors at compile time :(
 >
> Something like :

Thanks Eric. I guess at this point it doesn't really matter anymore
for the upstream kernel, but I'll apply your patch after getting
confirmation from Mariusz to make sure that people maintaining
external patches will notice the change (and won't send me broken
patches :)).
