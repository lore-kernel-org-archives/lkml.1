Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXC0KSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXC0KSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXC0KSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:18:31 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:47561 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXC0KSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:18:30 -0400
Date: Tue, 27 Mar 2007 12:18:29 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Agoston Horvath <agoston@ripe.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IPv6: Connection reset/timeout under heavy load
Message-Id: <20070327121829.596abb60.dada1@cosmosbay.com>
In-Reply-To: <4608E7CA.3090001@ripe.net>
References: <4608E7CA.3090001@ripe.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 11:45:46 +0200
Agoston Horvath <agoston@ripe.net> wrote:

> Hello,
> 
> I'm trying to add ipv6 support to the RIPE whois-server. I'm going with the dual-stack address familiy independent solution (/proc/sys/net/ipv6/bindv6only is set to 0).
> I've written a small piece of code which tests how the server behaves under heavy load. It basically creates a specified number of threads and hammers the query port of the server with logged real-world queries. This works fine over ipv4. But if I switch to ipv6 (meaning, instead of the ipv4 address of eth0, I give the ipv6 one to getaddrinfo()), strange connection reset/timeout problems arise. This is especially strange because it's all AF-independent, so the very same piece of code runs fine for ipv4, but fails for ipv6.

Hello Agoston

Could you please repost your mail on netdev@vger.kernel.org, because this address is more appropriate to get in touch with networking guys :)

Thank you
