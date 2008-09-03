Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYICAA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYICAA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYICAAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:00:48 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3369 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYICAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:00:47 -0400
Message-ID: <48BDD3A8.6070500@hp.com>
Date: Tue, 02 Sep 2008 17:00:40 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: alan@lxorguk.ukuu.org.uk, stephen.hemminger@vyatta.com,
       shemminger@vyatta.com, dusanc@gmail.com, romieu@fr.zoreil.com,
       hancockr@shaw.ca, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
References: <48BB295A.6050200@vyatta.com>	<20080901093827.24eec86f@lxorguk.ukuu.org.uk>	<48BD6C8E.5060704@hp.com> <20080902.164130.156055373.davem@davemloft.net>
In-Reply-To: <20080902.164130.156055373.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Rick Jones <rick.jones2@hp.com>
> Date: Tue, 02 Sep 2008 09:40:46 -0700
>>Can one change the TCP maximum RTO to be smaller than specified in the specs? 
> We always min-clamp the RTO at RTO calculation time in order to be
> compatible with BSD's coarse grained times.

But tuning TCP_RTO_MAX isn't permitted right?  I'm drawing (perhaps 
flawed) parallels/distinctions between what is/isn't permitted to tweak 
for timers for one protocol versus another and wondering which may be a 
case of sauce for the goose/gander.

rick jones
