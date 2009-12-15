Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZLOIqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZLOIqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZLOIqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:46:04 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:33604 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZLOIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:46:01 -0500
Message-ID: <4B274CC2.9030706@gmail.com>
Date: Tue, 15 Dec 2009 09:45:54 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: john.dykstra1@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
References: <20091214.111638.165984790.davem@davemloft.net>	<4B2690B4.3030604@gmail.com>	<20091214.143522.102450157.davem@davemloft.net> <20091214.231840.106434922.davem@davemloft.net>
In-Reply-To: <20091214.231840.106434922.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 15 Dec 2009 09:45:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/12/2009 08:18, David Miller a écrit :
> From: David Miller <davem@davemloft.net>
> Date: Mon, 14 Dec 2009 14:35:22 -0800 (PST)
> 
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Mon, 14 Dec 2009 20:23:32 +0100
>>
>>> If you disable syncookies, I presume you dont have warnings ?
>>
>> It happens even with syncookies disabled, hmmm...
> 
> FWIW, I'm starting to bisect this.


OK, I took a look at commit 05eaade2782fb0c90d3034fd7a7d5a16266182bb,
but I have no more time today for kernel dev, sorry :(


