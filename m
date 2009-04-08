Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbZDHD3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbZDHD3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZDHD3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:29:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZDHD3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:29:12 -0400
Message-ID: <49DC19D5.7090101@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 11:28:21 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IPv4/IPv6: update sysctl files
References: <49DC091C.6070708@cn.fujitsu.com> <1239158863.11534.52.camel@deadeye.i.decadent.org.uk>
In-Reply-To: <1239158863.11534.52.camel@deadeye.i.decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



on 04/08/2009 10:47 AM, Ben Hutchings wrote:
> On Wed, 2009-04-08 at 02:39 +0000, Shen Feng wrote:
>> Now the following sysctl files in /proc/sys/net/ipv4 are used by
>> both IPv4 and IPv6.
>> tcp_mem  tcp_rmem  tcp_wmem
>> udp_mem  udp_rmem_min  udp_wmem_min
>> Putting them in /proc/sys/net/ipv4 is not a good choice.
> [...]
> 
> But this is part of the ABI to userland.  You cannot remove sysctl files
> without long advance notice documented in feature-removal-schedule.txt
> (if at all).
> 
> If it is possible to add the paths
> /proc/sys/net/{tcp,udp} while retaining aliases under /proc/sys/net/ipv4
> then that might be a workable solution.

Thanks. That's a good solution.

But I'm still confused.
Why not create another tcp_mem in /proc/sys/net/ipv6?

Shen

> 
> Ben.
> 
