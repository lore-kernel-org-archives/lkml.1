Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbXESM5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbXESM5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbXESM47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:56:59 -0400
Received: from smtp1.iitb.ac.in ([203.78.217.177]:60959 "HELO smtp1.iitb.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752920AbXESM46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:56:58 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 08:56:57 EDT
Message-ID: <2770.10.107.26.27.1179579009.squirrel@gpo.iitb.ac.in>
Date: Sat, 19 May 2007 18:20:09 +0530 (IST)
Subject: Packets lost: Softirq
From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
To: linux-kernel@vger.kernel.org
Cc: vasanthakumar@iitb.ac.in
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: <3388.10.107.26.27.1179320821.squirrel@gpo.iitb.ac.in>
    <464B19A9.700@freemail.hu>
In-Reply-To: <464B19A9.700@freemail.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
 Please somebody guide me here. I desparatley need help regarding this
issue. ( plz do "reply to all")

 I am tracking all udp packets (in particular, SIP based UDP packets)that
goes through the iptables using LOG mechanism.
 I use the following command,
     iptables -A INPUT -p udp -j LOG --log-level-4.
     iptables -A FORWARD -p udp -j LOG --log-level-4

  In addition, i also run 'Ethereal' to make sure that all the packets
captured goes through the iptables as well.

  Here is the problem,
    Sometimes, a random number of packets doesnot go through IPtables and
  they are completely lost. Although, I can see those lost packets in
Ethereal. I tried increasing the backlog queue and ip_queue length, but
still no use.

   I am using Netgear's wireless network card (WG511, made in taiwan).
   Device driver: Prism54
   firmware: isl3890
   Kernel verison-- 2.6.11-6mdk

  Let me give you more insight into what I am trying do.

 I have a vitrual network interface and 2 physical network interface (one
Ethernet based, and other 802.11 based). The virtual network interface
dynamically binds to any one of the above physical interfaces for packet
transmission. The issue of packet loss occurs **only** during link
switching.

I feel that the following issues might be the possible reasons for the
packet loss.

1. Due to missing soft_IRQ interrupt for packets and hence packet loss ( i
have no proof to back this)
2. Due to incompatible wireless device driver.

Somebody please guide me. How do I findout the cause of this.

 Thank you,

  Regards
  Vasanth





