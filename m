Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXHNNNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXHNNNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXHNNNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:13:41 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34368 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXHNNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:13:40 -0400
Message-ID: <46C1AA82.1090403@s5r6.in-berlin.de>
Date: Tue, 14 Aug 2007 15:13:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: lepton <ytht.net@gmail.com>, lkm <linux-kernel@vger.kernel.org>,
       bcollins@debian.org, linux1394-user@lists.sourceforge.net
Subject: Re: I have two 1394 port in my computer, why did I get only one eth1394
 interface?
References: <20070813123555.GA6276@router.lepton.home> <46C0779D.3010401@s5r6.in-berlin.de> <Pine.LNX.4.64.0708141017571.30582@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708141017571.30582@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Aug 13 2007 17:24, Stefan Richter wrote:
>>The PHY may have several ports, but all of these ports belong to the same
>>FireWire bus. The PHY not only connect the link layer controller with each
>>port, it also acts as hub/repeater between those ports.
> 
> So given one has two firewire ports with only one PHY, it is not possible
> to make a firewall with two interfaces out of it, which each routed only to the
> specific firewire port...

Well, depends on whether one FireWire node could expose multiple network
interfaces on the same FireWire bus.  I'm not quite sure if the IPv4
over IEEE 1394 spec, RFC 2734, allows this.  It is however possible to
expose one RFC 2734 interface and one RFC 3146 interface (IPv6 over IEEE
1394) on the same bus --- hence it might also be possible to implement
more than one IPv4 interface per node per bus.  On a quick glance,
unicast doesn't seem to be a problem, but broadcast and multicast might be.

Linux' eth1394 driver implements only one IPv4 interface per bus, and no
IPv6 interface.

Anyway, an IP router from FireWire to FireWire seems to be a rather
exotic application, especially as LAN to internet router or firewall.
-- 
Stefan Richter
-=====-=-=== =--- -===-
http://arcgraph.de/sr/
