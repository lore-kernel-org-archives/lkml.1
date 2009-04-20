Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZDTSQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZDTSQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZDTSQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:16:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45047 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZDTSQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:16:23 -0400
Message-ID: <49ECBBF0.80202@cosmosbay.com>
Date: Mon, 20 Apr 2009 20:16:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: stefan novak <lms.brubaker@gmail.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bond interface arp, vlan and trunk / network question
References: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com>
In-Reply-To: <1ef444010904201050g72651387se3feca3fbd68ce30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 20 Apr 2009 20:16:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefan novak a écrit :
> Hello list,
> 
> I've got a Problem with my bladecenter and bond interfaces.
> My Server has 2 interface, each on a seperate switch. Each
> serverinterface is connected via a trunk to one of the switches.
> Each switch has a trunk to stacked-backbone switch.
> 
> nic1 --trunk--> bladesw1 --trunk--> backbone switch
> nic2 --trunk--> bladesw2 --trunk--> backbone switch
> 
> So far vlan and trunking works as expected. But if one trunk
> connection from a bladeswitch to the backbone switch is down the
> mii-tool cant recognize this.

What is the exact problem on this one ?

> I tried to use an arp target on the backbone switch to check the
> connection state.
> 
> Now i'm running into problems. :(
> My bladesw1 is configured with a trunk and a private vlan id of 600.
> On the backbone switch is a server in the vlan 600 connected, but i
> can't get an arp request.
> 
> What can be the problem, or is it possible to add a vlan tag on the arp check?
> 

What driver is in use on your NIC interface ?

Could you post your bonding settings ?

cat /proc/net/bonding/bond0


