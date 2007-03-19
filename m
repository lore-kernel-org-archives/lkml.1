Return-Path: <linux-kernel-owner+w=401wt.eu-S933840AbXCSFUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbXCSFUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933843AbXCSFUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:20:22 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:5951 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbXCSFUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:20:21 -0400
Date: Sun, 18 Mar 2007 23:20:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 1000xf bus problem
In-reply-to: <E8C008223DD5F64485DFBDF6D4B7F71D0289EDBF@msgswbmnmsp25.wellsfargo.com>
To: Greg.Chandler@wellsfargo.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Message-id: <45FE1D89.6020303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.wDPF1lWlqGQpxbyWee64Z3t4BVM@ifi.uio.no>
 <45FD95CD.2030403@shaw.ca>
 <E8C008223DD5F64485DFBDF6D4B7F71D0289EDBF@msgswbmnmsp25.wellsfargo.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg.Chandler@wellsfargo.com wrote:
> lspci -v shows the message below, and I am moving files between systems,
> {from RAMdisk to RAMdisk} on idle machines.
> The transfer rate is concurrent with just under the max throughput
> capable on a 64-bit/66Mhz PCI socket.

I think you miscalculate, that bus can transfer 532 MB/sec, Gigabit 
Ethernet tops out at 125 MB/sec at absolute maximum and it's difficult 
to achieve that in practice.

And what lspci reports is merely that the device supports 66MHz bus 
speed. That doesn't mean it doesn't support higher speeds and that 
doesn't mean that's what it's running at.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

