Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbXCLTXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbXCLTXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXCLTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:23:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:41108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXCLTXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:23:43 -0400
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: TCP MSG_PEEK kernel assertions ...
Date: Mon, 12 Mar 2007 12:22:23 -0700
Organization: OSDL
Message-ID: <20070312122223.3d5d7f48@freekitty>
References: <8C930983B0855DF-1728-4769@webmail-dd15.sysops.aol.com>
	<8C930AB112CB842-1728-4DAC@webmail-dd15.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1173727343 30808 10.8.0.54 (12 Mar 2007 19:22:23 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Mon, 12 Mar 2007 19:22:23 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Mar 2007 16:43:10 -0500
davef1624@aol.com wrote:

> 
>  Hello,
> 
>   I periodically see the following TCP kernel assertion errors in 
> /var/log/message
>   (it does seem that networking is eventually able to recover from these 
> errors):
> 
>   kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
> (1171)
>   kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
> (1171)
>   kernel: KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & 
> (MSG_PEEK | MSG_TRUNC))) failed at net/ipv4/tcp.c (1235)
>   kernel: KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c 
> (1171)
>   kernel: KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & 
> (MSG_PEEK | MSG_TRUNC))) failed at net/ipv4/tcp.c (1235)
> 
>   These errors only seem to occur when using the sk98lin (SysKonnect) 
> Network Device Driver,
>   and a Yukon Gigabit Ethernet 10/100/1000Base-T Adapter (from Marvell I 
> believe).
>  (The other NIC cards we're using in-house don't exhibit this issue).

Wrong mailing list. TCP errors should be sent to netdev@vger.kernel.org

>  I've seen postings concerning this issue over the past year or so,
>   but have not seen a clear resolution and/or understanding of the 
> root-cause of this issue.

Also please include more information, like what kernel version and what
other networking features you are using like VLAN's, netfiltering, ...

>   I'm in the process of upgrading my sk98lin network driver to the 
> latest from SysKonnect
>  in an attempt to see if this corrects the problem.

No, that driver is worse, try the skge driver. The sk98lin driver
is headed for removal

>  Does anybody have any insight into this problem?
> 
>  Best regards,
>  Dave F
> 
> 
>   
> ________________________________________________________________________ 
> 
>   AOL now offers free email to everyone. Find out more about what's free 
> from AOL at AOL.com.
>  -
>   To unsubscribe from this list: send the line "unsubscribe linux-net" 
> in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at http://vger.kernel.org/majordomo-info.html
> 
> 
> ________________________________________________________________________
> AOL now offers free email to everyone.  Find out more about what's free 
> from AOL at AOL.com.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
