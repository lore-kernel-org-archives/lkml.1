Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbYGXAph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbYGXAph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYGXApa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:45:30 -0400
Received: from qult.net ([82.238.217.46]:44992 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbYGXAp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:45:29 -0400
X-Greylist: delayed 3013 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 20:45:29 EDT
Date: Thu, 24 Jul 2008 01:55:14 +0200
From: Ignacy Gawedzki <lkml@qult.net>
To: linux-kernel@vger.kernel.org
Subject: TUN/TAP hacking
Message-ID: <20080723235514.GA8992@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need some advice from network stack experts, so I hope this is the right
place to ask.

I thought I'd be able to use the TAP interfaces to create some sort of a
network emulator.  For a start I just "bridged" two tap interfaces, much in
the same way as the example of br_select.c from http://vtun.sf.net , assigned
both interfaces different IPv4 addresses (both with a /32 prefix), set them up
and tried to transmit a UDP packet from one address to the other through the
bridge.  Both logs from my bridge program and tcpdump tell me that the packets
are flowing as expected, but somehow the destination process doesn't get the
packets (despite all correct bind, etc).

Is it simply that the stack inconditionally drops any packet with the same
source (IP and/or MAC) address as some local interface?

As ARP resolution seems not to work either (I had to put permanent entries in
the neighbor table), I suppose this is the case indeed.

Could anyone confirm that? (please CC me, I've not subscribed)

Thanks,

Ignacy

-- 
If you're not living on the edge, you're taking up too much space.
