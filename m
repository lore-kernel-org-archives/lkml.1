Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZL3PhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZL3PhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 10:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZL3PhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 10:37:12 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:33082 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZL3PhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 10:37:11 -0500
Date: Wed, 30 Dec 2009 10:36:33 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
In-reply-to: <20091230000724.4083e7dd@nehalam>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Message-id: <4B3B7381.9050408@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B300A2A.8040305@gmail.com> <4B300E30.9090707@majjas.com>
 <4B3114E3.1070602@majjas.com> <4B329FA3.9090904@majjas.com>
 <20091223230102.4bb0100e.akpm@linux-foundation.org>
 <20091230000724.4083e7dd@nehalam>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What has been running on eth0 (usual for me ... perhaps relevant to the 
issue) when I've seen the errors. As noted previously, there is a 
correlation with dhcp, and maybe one with dns over ipv6.

Console is local (nouveau kms).

As per Stephen's other email, I'm rerunning with kernel debug enabled. 
I'll also try nomodeset and could if need by (but a real PITA) can swap 
video cards with an ATI card.

ipv6
appletalk
dhcpd
smb
dns (bind9)
X11 (accessing box via cygwin)
sendmail
imap
mediatomb
On 12/30/2009 3:07 AM, Stephen Hemminger wrote:
> On Wed, 23 Dec 2009 23:01:02 -0800
> Andrew Morton<akpm@linux-foundation.org>  wrote:
>
>    
>>> Dec 23 17:32:58 mail kernel: DRHD: handling fault status reg 2
>>> Dec 23 17:32:58 mail kernel: DMAR:[DMA Read] Request device [06:00.0]
>>> fault addr fff8423fe000
>>> Dec 23 17:32:58 mail kernel: DMAR:[fault reason 06] PTE Read access is
>>> not set
>>> Dec 23 17:32:58 mail kernel: sky2 0000:06:00.0: error interrupt
>>> status=0x80000000
>>> Dec 23 17:32:58 mail kernel: sky2 0000:06:00.0: PCI hardware error (0x2010)
>>> Dec 23 17:33:06 mail kernel: ------------[ cut here ]------------
>>> Dec 23 17:33:06 mail kernel: WARNING: at net/sched/sch_generic.c:255
>>> dev_watchdog+0xf3/0x161()
>>> Dec 23 17:33:06 mail kernel: Hardware name: System Product Name
>>> Dec 23 17:33:06 mail kernel: NETDEV WATCHDOG: eth0 (sky2): transmit
>>>        
> Just to reiterate, these are consistent with a DMA error on transmit.
> Since is 4 seconds after the DHCPACK, they probably are not related, except
> that when DHCP renew may have caused more traffic.
>
> Are you using something like network console or kgdb, or anything that could
> be using some unusual network I/O?
>    

