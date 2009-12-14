Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbZLNTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbZLNTXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZLNTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:23:38 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:55839 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbZLNTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:23:37 -0500
Message-ID: <4B2690B4.3030604@gmail.com>
Date: Mon, 14 Dec 2009 20:23:32 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: john.dykstra1@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
References: <4B267708.3010202@gmail.com>	<1260817033.9141.8.camel@merlyn>	<20091214.111105.224947761.davem@davemloft.net> <20091214.111638.165984790.davem@davemloft.net>
In-Reply-To: <20091214.111638.165984790.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 20:23:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 20:16, David Miller a écrit :
> From: David Miller <davem@davemloft.net>
> Date: Mon, 14 Dec 2009 11:11:05 -0800 (PST)
> 
>> I usually see 2 or 3 three of these bug triggers in the first ten
>> minutes after bootup and I haven't seen one yet in 20 minutes
>> with the commit reverted.
> 
> Nevermind, I take that back, I just got two triggers :-/

ok :)

More investigation needed :)

I wonder which workload triggers this...

If you disable syncookies, I presume you dont have warnings ?

