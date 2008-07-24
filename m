Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbYGXCgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbYGXCgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 22:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYGXCgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 22:36:31 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:43091 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGXCga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 22:36:30 -0400
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 22:36:30 EDT
Message-ID: <4887E818.4020305@isomerica.net>
Date: Wed, 23 Jul 2008 22:25:28 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Ignacy Gawedzki <lkml@qult.net>, linux-kernel@vger.kernel.org
CC: NetDev <netdev@vger.kernel.org>
Subject: Re: TUN/TAP hacking
References: <20080723235514.GA8992@zenon.in.qult.net>
In-Reply-To: <20080723235514.GA8992@zenon.in.qult.net>
X-Enigmail-Version: 0.95.6
OpenPGP: url=http://isomerica.net/~dpn/gpgkey
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignacy Gawedzki wrote:
> I need some advice from network stack experts, so I hope this is the right
> place to ask.

The Linux kernel networking folks hang out at netdev
(netdev@vger.kernel.org).  I've CC'd them...

> I thought I'd be able to use the TAP interfaces to create some sort of a
> network emulator.  For a start I just "bridged" two tap interfaces, much in
> the same way as the example of br_select.c from http://vtun.sf.net , assigned
> both interfaces different IPv4 addresses (both with a /32 prefix), set them up
> and tried to transmit a UDP packet from one address to the other through the
> bridge.  Both logs from my bridge program and tcpdump tell me that the packets
> are flowing as expected, but somehow the destination process doesn't get the
> packets (despite all correct bind, etc).
> 
> Is it simply that the stack inconditionally drops any packet with the same
> source (IP and/or MAC) address as some local interface?
> 
> As ARP resolution seems not to work either (I had to put permanent entries in
> the neighbor table), I suppose this is the case indeed.
> 
> Could anyone confirm that? (please CC me, I've not subscribed)
> 
> Thanks,
> 
> Ignacy
> 


-- 
                    /--------------- - -  -  -   -   -
                    |  Dan Noé
                    |  http://isomerica.net/~dpn/
