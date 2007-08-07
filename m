Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbXHGEa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbXHGEa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759103AbXHGEap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:30:45 -0400
Received: from smtpout.mac.com ([17.250.248.172]:58660 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXHGEan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:30:43 -0400
In-Reply-To: <1186443467.11680.1204059001@webmail.messagingengine.com>
References: <1186443467.11680.1204059001@webmail.messagingengine.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6CADE9C0-2EE3-4404-B33B-0941533933D2@mac.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Creating virtual interface triggers an IGMPv3 Join to Multicast DNS
Date: Tue, 7 Aug 2007 00:30:36 -0400
To: Adam M <lkml@irotas.net>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 06, 2007, at 19:37:47, Adam M wrote:
> Hi folks,
>
> For some reason, every time I create a virtual interface (using  
> tun), the interface immediately generates an IGMPv3 Join packet for  
> group 224.0.0.251, which (according to Google) is Multicast DNS.
>
> This packet is generated automatically and consistently. I'm  
> wondering why this should be the case, and if it can be disabled.

You don't happen to be running "avahi" or one of the other Zeroconf/ 
Bonjour/Rendezvous/$P2P_BUZZWORD_OF_THE_WEEK local-network-discovery  
daemons, do you?  Most of those keep an eye out for new network  
interfaces and automatically start pushing multicast packets down  
them as soon as they appear, which is the most likely explanation for  
what you are seeing; as opposed to a kernel issue.

Cheers,
Kyle Moffett

