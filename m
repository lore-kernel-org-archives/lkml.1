Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbXFGURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbXFGURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760919AbXFGUQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:16:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbXFGUQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:16:53 -0400
Date: Thu, 7 Jun 2007 13:15:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.22-rc4-mm2 -- ipw2200 -- SIOCSIFADDR: No buffer space
 available
Message-Id: <20070607131559.cd95a181.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
References: <a44ae5cd0706071125p2079472eme52821bd134d26b0@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:25:30 -0700
"Miles Lane" <miles.lane@gmail.com> wrote:

> Hi Andrew,
> 
> This might be some problem with my kernel configuration.
> I added:
> CONFIG_BONDING=y
> 
> # dhclient eth1
> There is already a pid file /var/run/dhclient.pid with pid 134993416
> Internet Systems Consortium DHCP Client V3.0.4
> Copyright 2004-2006 Internet Systems Consortium.
> All rights reserved.
> For info, please visit http://www.isc.org/sw/dhcp/
> SIOCSIFADDR: No buffer space available
> Listening on LPF/eth1/00:12:f0:5e:db:2f
> Sending on   LPF/eth1/00:12:f0:5e:db:2f
> Sending on   Socket/fallback
> DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 6
> DHCPOFFER from 192.168.1.1
> DHCPREQUEST on eth1 to 255.255.255.255 port 67
> DHCPACK from 192.168.1.1
> SIOCSIFADDR: No buffer space available
> SIOCSIFNETMASK: Cannot assign requested address
> SIOCSIFBRDADDR: Cannot assign requested address
> SIOCADDRT: Network is unreachable
> bound to 192.168.1.2 -- renewal in 2993 seconds.
> 
> # ping www.yahoo.com
> ping: unknown host www.yahoo.com
> 
> Any suggestions what to try now?  I'll go ahead and turn off the
> bonding option and see if that helps.
> 

It won't be related to bonding.

It has a high probability of being very related to Herbert's changes
to inet_set_ifa().
