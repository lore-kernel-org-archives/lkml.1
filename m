Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbXJJHEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbXJJHEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 03:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXJJHEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 03:04:13 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:53780 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXJJHEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 03:04:12 -0400
Message-ID: <470C7898.1060405@cosmosbay.com>
Date: Wed, 10 Oct 2007 09:00:40 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Freund <linux-kernel-news@e-dict.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: sometimes very long response times on network interfaces since
 2.6.22
References: <470C724A.9010403@e-dict.net>
In-Reply-To: <470C724A.9010403@e-dict.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 10 Oct 2007 09:00:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Freund a écrit :
> Hello,
> 
> since I switched to kernel 2.6.22 my dell 1750 server
> with the two onboard BCM5704 network interfaces doesn't
> work properly anymore.
> TCP requests sometimes need more than 30 seconds to be answered
> (or to get away) and the application stops with timeouts.
> We are talking about two servers connected via Gigabit switch.
> The timeouts happen up to ten times a day.
> In the meantime I tried an old 3com 3c905c NIC which showed
> the same behaviour.
> I still couldn't figure out in which special situation the
> communication stops.
> The only solution ist to boot the old 2.6.21.5 kernel.
> With this, all runs fine.
> Did I miss a config issue in the migration to 2.6.22?
> The machines run in a productive environment and there is
> not much room (time) to debug, but if needed, I could try
> if anyone would need more information for help.
> 

Hi
1) A tcpdump would help for sure...
2) Could you try 2.6.23
