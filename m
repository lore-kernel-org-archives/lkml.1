Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXFUXyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXFUXyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXFUXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:54:44 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:48203 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXFUXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:54:43 -0400
Date: Thu, 21 Jun 2007 17:53:25 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Broadcom (bnx2) on PE1950/2950 failure
In-reply-to: <fa.GUDTRJ+yqLKq4z8Xd89auM7cYdk@ifi.uio.no>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org
Message-id: <467B0F75.5020900@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GUDTRJ+yqLKq4z8Xd89auM7cYdk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fortier,Vincent [Montreal] wrote:
> Here is part of the dmesg:
> [root@localhost /root]# dmesg | grep -i eth
> [  119.196375] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2
> v1.5.8.1 (May 7, 2007)
> [  119.215023] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
> 64-bit 133MHz found at mem f8000000, IRQ 17, node addr 0019b9c8eedc
> [  119.246853] eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
> 64-bit 133MHz found at mem f4000000, IRQ 16, node addr 0019b9c8eede
> [  119.458598] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network
> Connection
> [  119.654095] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network
> Connection
> [  266.513144] bnx2: eth3: using MSI
> [  269.638237] bnx2: eth3 NIC Link is Up, 1000 Mbps full duplex, receive
> & transmit flow control ON
> [  290.242533] eth3: no IPv6 routers present
> 
> As you can notice it tried to use eth0 & eth1 for both broadcom adapters
> but it did not worked properly since e1000 used them instead and finally
> bnx2 got eth3 working using MSI ?

Huh? eth0 and eth1 are the e1000 adapters, eth3 (and presumably eth2) 
are the bnx2 adapters..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

