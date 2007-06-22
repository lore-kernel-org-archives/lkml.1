Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXFVW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXFVW6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXFVW6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:58:14 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:45078 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXFVW6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:58:13 -0400
Date: Fri, 22 Jun 2007 16:56:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Broadcom (bnx2) on PE1950/2950 failure
In-reply-to: <F1D642E5A91BC94D9504EC83AE19E6B0128A40@ecqcmtlmail3.quebec.int.ec.gc.ca>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org
Message-id: <467C53B9.3030102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GUDTRJ+yqLKq4z8Xd89auM7cYdk@ifi.uio.no>
 <467B0F75.5020900@shaw.ca>
 <F1D642E5A91BC94D9504EC83AE19E6B0128A40@ecqcmtlmail3.quebec.int.ec.gc.ca>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fortier,Vincent [Montreal] wrote:
> Here is the output of the dmesg with now the appropriate order:
> [root@urpdev1 /etc]# dmesg | grep -i eth
> [  120.685696] Broadcom NetXtreme II Gigabit Ethernet Driver bnx2
> v1.5.8.1 (May 7, 2007)
> [  120.703846] eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
> 64-bit 133MHz found at mem f8000000, IRQ 17, node addr 0019b9c8eedc
> [  120.735350] eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X
> 64-bit 133MHz found at mem f4000000, IRQ 16, node addr 0019b9c8eede
> [  120.921403] e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network
> Connection
> [  121.069025] e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network
> Connection
> [  267.720475] bnx2: eth0: using MSI
> [  270.832235] bnx2: eth0 NIC Link is Up, 1000 Mbps full duplex, receive
> & transmit flow control ON
> 
> 
> But still, there is a problem with the second Broadcom port (eth1):
> [root@urpdev1 /etc]# mii-tool
> eth0: negotiated 100baseTx-FD flow-control, link ok
> SIOCGMIIPHY on 'eth1' failed: Resource temporarily unavailable
> eth2: negotiated 100baseTx-FD flow-control, link ok
> eth3: negotiated 100baseTx-FD flow-control, link ok
> 
> I don't get it?
> 
> Help appreciated.

Is that interface down? mii-tool probably doesn't work in that case..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

