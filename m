Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYKGLT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYKGLT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 06:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYKGLTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 06:19:12 -0500
Received: from no-dns-yet.demon.co.uk ([80.176.108.50]:62068 "HELO
	mailgate.blueteddy.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1751828AbYKGLTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 06:19:11 -0500
Message-ID: <4914240F.7050701@blueteddy.net>
Date: Fri, 07 Nov 2008 11:18:39 +0000
From: Dave Hudson <linux-kernel@blueteddy.net>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
CC: Mikael Abrahamsson <swmike@swm.pp.se>, David Miller <davem@davemloft.net>,
       daniel.blueman@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com> <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se> <20081105.151015.206163697.davem@davemloft.net> <alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se> <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ilpo Järvinen wrote:
> On Fri, 7 Nov 2008, Mikael Abrahamsson wrote:
> 
> And about somebody earlier claiming that they'll get an impressions that 
> Linux stack is broken (if such people even know that there's some network 
> stack in Linux :-))... I'm rather sure those isp supports etc. put a blaim 
> on us anyway even when loads of counterproof would exists because it's 
> just cheaper to do nothing and blaim linux instead. Also some claims 
> asserted by incompetent people easily start to live among random forums; 
> an example from the previous incident: "since disabling timestamps helps, 
> it must be that timestamps are broken" (and somebody even "more clueful" 
> added that they got enabled for 2.6.27?!?), needless to say, neither 
> holds.

Not all of the routers in question (the ones that crash, block packets 
or otherwise misbehave) are provided by ISPs - in fact a huge number of 
them are and have been sold retail.  Over time most of those boxes will 
get replaced with ones that don't have the problem because most 
(probably all major) SOHO router suppliers now test that they don't 
break with ECN so eventually there will be a point where enabling ECN by 
default will make a lot of sense (there will be too few broken routers 
to care about).

What I do believe (having spent a lot of years writing embedded device 
and router code - and no, not the ones that crash ;-)) is that if you 
enable a feature that causes just 1% of users to have an out-of-the-box 
problem you'll see a seriously disproportionate response from end users. 
  Most people (and engineers are not "most people" :-)) will blame the 
new thing that they've just added or changed, not the old thing that was 
broken to begin with (it's human nature not to truly understand cause 
and effect).

Whether we like it or not there's currently a known problem deploying 
ECN on a wide scale - it has been sufficient to stop pretty-much 
everyone from enabling it by default so far.


Regards,
Dave


