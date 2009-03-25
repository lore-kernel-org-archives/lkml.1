Return-Path: <linux-kernel-owner+w=401wt.eu-S1761201AbZCYQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201AbZCYQF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757408AbZCYQFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:05:09 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:22301 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZCYQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:05:07 -0400
Message-ID: <49CA55F0.9030203@oracle.com>
Date: Wed, 25 Mar 2009 09:04:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       netdev@vger.kernel.org
Subject: Re: Next March 25: staging/epl build break.
References: <20090325191229.0e17eaf6.sfr@canb.auug.org.au> <49CA18D9.6080302@in.ibm.com>
In-Reply-To: <49CA18D9.6080302@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49CA5622.01A7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> Today's next x86 randconfig build failed with
> 
> drivers/staging/epl/VirtualEthernetLinux.c: In function VEthAddInstance:
> drivers/staging/epl/VirtualEthernetLinux.c:302: error: struct net_device
> has no member named open
> drivers/staging/epl/VirtualEthernetLinux.c:303: error: struct net_device
> has no member named stop
> drivers/staging/epl/VirtualEthernetLinux.c:304: error: struct net_device
> has no member named get_stats
> drivers/staging/epl/VirtualEthernetLinux.c:305: error: struct net_device
> has no member named hard_start_xmit
> drivers/staging/epl/VirtualEthernetLinux.c:306: error: struct net_device
> has no member named tx_timeout


There are lots of build errors similar to this, in appletalk, irda,
tokenring, etc etc...


-- 
~Randy
