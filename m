Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbXH3LZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbXH3LZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 07:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXH3LY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 07:24:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42127 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbXH3LYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 07:24:55 -0400
Message-Id: <1188473093.28603.1208050067@webmail.messagingengine.com>
X-Sasl-Enc: ctJ7V1Qd5KGB6hsJpy1eR3bIL6oMPOZR2uUo566EEXU1 1188473093
From: "Harsha" <hlforums@fmguy.com>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: ethernet driver: hard_start_xmit
Date: Thu, 30 Aug 2007 04:24:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have written a network device driver (Linux kernel: 2.6.20.1) on ARM
based target board.
I have implemented ether_tx, which is called whenever hard_start_xmit is
called.

--------------------------------------
[ PINGing from BOARD TO OTHER HOST ]

The network driver is working.  I am able to ping to other hosts and i
am able to get the reply without any problem

Q1.  For large packet size say (2048, 4096) after sometime ping exits
saying "sendto: buffer space unavailable"

---------------------------------------
[ PINGing from other HOST to BOARD ]

ping works but only for some time.  It stops working by saying "Request
timed out" after some successful pinging.
The number of times ping succeeds depend on the packet size

Packet size = 64, ping stops working exactly after 449 times
Packet size = 4096, ping stops working exactly after 28 times.

I did some digging and found that when ping stops working, ether_tx(or
hard_start_xmit) is not called at all.  Though the packets are recieved
correctly by ether_rx.  After ping stops, any more ping of any packet
size does not work. Also i found that at this stage if i ping from board
to host it works.

Q2.  What might be the reason for ping to stop?

Regards
harsha




-- 
  Harsha
  hlforums@fmguy.com

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

