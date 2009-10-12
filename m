Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbZJLWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbZJLWmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbZJLWmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:42:18 -0400
Received: from radagast.issp.eu ([86.59.99.45]:48872 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbZJLWmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:42:18 -0400
Message-ID: <20091013004140.84685h783tt8jfcw@www.kundendienste.net>
Date: Tue, 13 Oct 2009 00:41:40 +0200
From: lkml@makubi.at
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
References: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
 <200910130008.57174.arnd@arndb.de>
In-Reply-To: <200910130008.57174.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, but for example ICMP also uses raw sockets and gets blocked if I  
do not explicit allow it, doesn't it?

> On Monday 12 October 2009, lkml@makubi.at wrote:
>> Well, I just looked for "ethernet protocol" and read some things about
>> DHCP again.
>>
>> What's an ethernet protocol?
>>
>> I also read, that "DHCP is built directly on UDP and IP" (RFC 2131).
>>
>> It uses Ports (UDP 67/68) and the source address of the DHCP server is
>> an IP address.
>
> Ah, right. I confused it with the way that the ancient RARP protocol did
> this before DHCP.
>
> Sorry for the confusion.
>
>> Could you answer me more in detail, why I get an IP, but block
>> everything with iptables?
>
> The dhcp client opens a raw packet socket at the ethernet device
> (if I'm not mistaken again), because there is no IP address assigned
> with the netdev at that time. This allows it to send and receive
> ethernet frames, bypassing the TCP/IP stack.
>
> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


