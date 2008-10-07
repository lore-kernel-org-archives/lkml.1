Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYJGJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYJGJ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYJGJ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:28:39 -0400
Received: from gate1.ipvision.dk ([217.195.186.3]:56414 "EHLO
	gate1.ipvision.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYJGJ2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:28:39 -0400
X-Greylist: delayed 2022 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 05:28:38 EDT
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>
	<48EA8197.6080502@cosmosbay.com>
	<20081006.144002.56418911.davem@davemloft.net>
	<48EAF29D.8050203@cosmosbay.com>
From: Benny Amorsen <benny+usenet@amorsen.dk>
Date: Tue, 07 Oct 2008 10:54:42 +0200
In-Reply-To: <48EAF29D.8050203@cosmosbay.com> (Eric Dumazet's message of "Tue\, 07 Oct 2008 07\:24\:45 +0200")
Message-ID: <m37i8k3hv1.fsf@ursa.amorsen.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -6.3 (------)
X-Spam-Report: ALL_TRUSTED=-3.3, AWL=0.102, BAYES_00=-3.099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:

> Most UDP sockets are setup for long periods (RTP trafic), or if an application really
> wants to {open/send or receive one UDP frame/close} many sockets, it already hits
> RCU handling of its file structures and should not be slowed down that much.
>
> By 'long period' I mean thousand of packets sent/received by each RTP session, being
> voice (50 packets/second) or even worse video...

Does DNS with port randomization need short lived sockets?


/Benny

