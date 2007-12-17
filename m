Return-Path: <linux-kernel-owner+w=401wt.eu-S937155AbXLQULw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937155AbXLQULw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765719AbXLQTs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:48:29 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:56209 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765692AbXLQTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:48:27 -0500
Message-ID: <4766D261.1020005@nortel.com>
Date: Mon, 17 Dec 2007 13:47:45 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: yoshfuji@linux-ipv6.org, dada1@cosmosbay.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: "ip neigh show" not showing arp cache entries?
References: <4760279E.1080203@nortel.com>	<47602DD0.8070402@cosmosbay.com> <47605934.2060604@nortel.com> <20071213.070641.20411400.yoshfuji@linux-ipv6.org> <476696A5.1010101@nortel.com> <4766B99D.8060408@trash.net>
In-Reply-To: <4766B99D.8060408@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2007 19:47:48.0907 (UTC) FILETIME=[B3D8AFB0:01C840E5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:

>  From a kernel perspective there are only complete dumps, the
> filtering is done by iproute. So the fact that it shows them
> when querying specifically implies there is a bug in the
> iproute neighbour filter. Does it work if you omit "all"
> from the ip neigh show command?

Omitting "all" gives identical results.  It is still missing entries 
when compared with the output of "arp".

Chris
