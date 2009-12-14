Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbZLNTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbZLNTWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbZLNTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:22:19 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:55819 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbZLNTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:22:18 -0500
Message-ID: <4B269065.5000601@gmail.com>
Date: Mon, 14 Dec 2009 20:22:13 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: john.dykstra1@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
References: <20091213.234530.82029083.davem@davemloft.net>	<4B267708.3010202@gmail.com>	<1260817033.9141.8.camel@merlyn> <20091214.111105.224947761.davem@davemloft.net>
In-Reply-To: <20091214.111105.224947761.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 20:22:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 20:11, David Miller a écrit :
> From: John Dykstra <john.dykstra1@gmail.com>
> Date: Mon, 14 Dec 2009 18:57:13 +0000
> 
>> That test was changed to match a change in the return values of
>> tcp_ack().  No logic change was intended.
> 
> As Eric pointed out, changing tcp_ack()'s behavior effects state
> transitions out of SYN_ACK, so this commit is very likely the culprit.
> 
> I usually see 2 or 3 three of these bug triggers in the first ten
> minutes after bootup and I haven't seen one yet in 20 minutes
> with the commit reverted.
> 
> This change is definitely wrong.

Hmm, I didnt yet spotted the problem, just gave some hints ...


