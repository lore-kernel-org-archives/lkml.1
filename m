Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYKGOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYKGOa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYKGOaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:30:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57667 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751543AbYKGO36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:29:58 -0500
Date: Fri, 7 Nov 2008 14:29:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Hudson <linux-kernel@blueteddy.net>
Cc: Ilpo =?ISO-8859-14?B?SuRydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
       Mikael Abrahamsson <swmike@swm.pp.se>,
       David Miller <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
Message-ID: <20081107142950.13906925@lxorguk.ukuu.org.uk>
In-Reply-To: <4914240F.7050701@blueteddy.net>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	<alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	<20081105.151015.206163697.davem@davemloft.net>
	<alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
	<Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
	<4914240F.7050701@blueteddy.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not all of the routers in question (the ones that crash, block packets 
> or otherwise misbehave) are provided by ISPs

The ones that block and misbehave are the bigger problem. The ones that
crash are less of a problem and I think they are less common. Certainly
if they were common then people would be abusing the flaw routinely.
Similar end users tend to grasp "if it keeps crashing blame the supplier".

When stuff just mysteriously doesn't work it is a whole lot more
problematic. I think however Sally Floyd had it right and Alexey has it
wrong (as does Davem).

If you turn it off on a retransmit then you provide an immediate
incentive for everyone on the web server end of the business to fix their
network. Especially if you turn it off for second retransmit. That will
cause faulty ECN handling sites to feel "a bit slow" and we know from
marketing data that web site performance is crucial to customer base. A
three or four second delay getting a page up translates into dramatically
reduced hit counts.

Alan
