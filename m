Return-Path: <linux-kernel-owner+w=401wt.eu-S965738AbXCSG47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbXCSG47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 02:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965742AbXCSG47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 02:56:59 -0400
Received: from 1wt.eu ([62.212.114.60]:1258 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965738AbXCSG46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 02:56:58 -0400
Date: Mon, 19 Mar 2007 07:56:41 +0100
From: Willy Tarreau <w@1wt.eu>
To: Robin Humble <rjh+e1000@cita.utoronto.ca>
Cc: Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Greg.Chandler@wellsfargo.com
Subject: Re: [E1000-devel] 1000xf bus problem
Message-ID: <20070319065641.GA7550@1wt.eu>
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no> <45FD95CD.2030403@shaw.ca> <E8C008223DD5F64485DFBDF6D4B7F71D0289EDBF@msgswbmnmsp25.wellsfargo.com> <45FE1D89.6020303@shaw.ca> <20070319053151.GU943@1wt.eu> <20070319055932.GA17345@lemming.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319055932.GA17345@lemming.cita.utoronto.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 01:59:32AM -0400, Robin Humble wrote:
> On Mon, Mar 19, 2007 at 06:31:51AM +0100, Willy Tarreau wrote:
> >On Sun, Mar 18, 2007 at 11:20:09PM -0600, Robert Hancock wrote:
> >> Greg.Chandler@wellsfargo.com wrote:
> >> >lspci -v shows the message below, and I am moving files between systems,
> >> >{from RAMdisk to RAMdisk} on idle machines.
> >> >The transfer rate is concurrent with just under the max throughput
> >> >capable on a 64-bit/66Mhz PCI socket.
> >> 
> >> I think you miscalculate, that bus can transfer 532 MB/sec, Gigabit 
> >> Ethernet tops out at 125 MB/sec at absolute maximum and it's difficult 
> >> to achieve that in practice.
> >
> >On TCP payload, you should achieve 118.66 * 10^6 bytes/s ~= 113 MB/s.
> 
> times 2 for full duplex.

perfectly, I was talking about something easy to measure (ftp...)

> so a 32bit/33MHz bus = 132MB/s isn't enough for fdx, but anything more
> (64bit or 66MHz or both) should be fine.

Not even, in fact, you have to subtract the PCI overhead. It is very hard to
go beyond 800 Mbps half duplex on PCI/33/32bits, so if you have either 64bits
or 66 MHz, you won't go past 1.6 Gbps FD, or a little less than 200 MB/s.

66*64 is really required to simultaneously achieve 1 Gbps in both directions.

Regards,
Willy

