Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYCBPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYCBPnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYCBPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:42:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2357 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752445AbYCBPm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:42:58 -0500
Date: Sun, 2 Mar 2008 11:46:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lukas Razik <linux@razik.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ethernet over Kernel Sockets
Message-ID: <20080302104650.GC3861@ucw.cz>
References: <47C870FD.4000808@razik.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C870FD.4000808@razik.name>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-29 21:54:21, Lukas Razik wrote:
> Hello all!
> 
> As you know, some network cards doesn't have a 'eth' 
> interface under linux.
> Because of that I'm developing a net_device based driver 
> which doesn't transmit and receive directly through a 
> real network card but through UDP kernel sockets.

What is it good for?

> So the eth1 interfaces are based on sockets which use 
> the eth0 (Gigabit) interfaces for the communication.
> Now, if I measure the transmission between 192.168.0.1 
> and 192.168.0.2 then I get transmission rates that are 
> normal for Gigabit-Ethernet (~25?sec (PingPong) and 
> ~900Mbit/s).
> If I measure the transmission through the eth1 
> interfaces between 192.168.1.1 and 192.168.1.2 then I 
> only get ~1msec (PingPong) and only about ~400Mbit/s.
> 
> The interesting thing is, that I always get PingPongs of 
> 1ms (= one jiffie). Although if I measure with 100MBit- 
> or other non-Ethernet cards.

Try increasing HZ :-)... or maybe it is a gigabit interrupt mitigation
issue?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
