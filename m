Return-Path: <linux-kernel-owner+w=401wt.eu-S965452AbXCSFcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965452AbXCSFcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965466AbXCSFcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:32:06 -0400
Received: from 1wt.eu ([62.212.114.60]:1253 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXCSFcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:32:05 -0400
Date: Mon, 19 Mar 2007 06:31:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg.Chandler@wellsfargo.com, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: 1000xf bus problem
Message-ID: <20070319053151.GU943@1wt.eu>
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca> <E8C008223DD5F64485DFBDF6D4B7F71D0289EDBF@msgswbmnmsp25.wellsfargo.com> <45FE1D89.6020303@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FE1D89.6020303@shaw.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2007 at 11:20:09PM -0600, Robert Hancock wrote:
> Greg.Chandler@wellsfargo.com wrote:
> >lspci -v shows the message below, and I am moving files between systems,
> >{from RAMdisk to RAMdisk} on idle machines.
> >The transfer rate is concurrent with just under the max throughput
> >capable on a 64-bit/66Mhz PCI socket.
> 
> I think you miscalculate, that bus can transfer 532 MB/sec, Gigabit 
> Ethernet tops out at 125 MB/sec at absolute maximum and it's difficult 
> to achieve that in practice.

On TCP payload, you should achieve 118.66 * 10^6 bytes/s ~= 113 MB/s.
This is what you should observe with FTP or netcat for instance. On
local networks, it is perfectly attainable, I do this every day. If you
are far from this, check both sides link status with ethtool, and ensure
that you do not have wiring problems. It is usually very easy to fill the
wire with an e1000.

Also, it would be interesting to check the other side. What card does it
have, what bus, what driver ? And what software or tests are you using
to conclude that you're limited by the bus ?

Regards,
Willy

