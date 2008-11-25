Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYKYVvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYKYVvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYKYVvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:51:40 -0500
Received: from buick.jordet.net ([193.91.240.190]:36130 "EHLO buick.jordet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYKYVvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:51:40 -0500
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Stian Jordet <liste@jordet.net>, Sven-Haegar Koch <haegar@sdinet.de>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <492C6C9B.3060000@sandeen.net>
References: <1226760254.5089.11.camel@chevrolet>
	 <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	 <1227476908.32357.5.camel@chevrolet>
	 <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	 <1227485956.5145.10.camel@chevrolet>
	 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
	 <1227569808.5039.6.camel@chevrolet>
	 <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
	 <1227645887.7992.10.camel@chevrolet>  <492C6C9B.3060000@sandeen.net>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 22:51:33 +0100
Message-Id: <1227649893.6557.10.camel@oldsmobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ti., 25.11.2008 kl. 15.22 -0600, skrev Eric Sandeen:
> Depending on the old system, perhaps its storage did not allow the
> barriers to be honored, so after xfs saw a test barrier write fail at
> mount time, it disabled them ... you'd see a message if that were the
> case, FWIW.

I know those messages, I get them on my old server. But my old
workstation did not disable the barrier...

But I still don't understand this. On my laptop (HP EliteBook 8530w,
very very powerful, but still a laptop, not an eight core, hardware raid
workstation...), I get this (xfs partition):

barrier:

time bash -c 'tar xjf linux-2.6.27.7.tar.bz2; sync'

real	1m30.855s
user	0m23.265s
sys	0m4.096s

nobarrier:

time bash -c 'tar xjf linux-2.6.27.7.tar.bz2; sync'

real	0m37.602s
user	0m15.281s
sys	0m4.184s

With no barriers, it's 22s faster than my workstation. That can't be the
way it's supposed to be?

-Stian

