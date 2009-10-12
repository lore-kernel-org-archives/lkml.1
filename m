Return-Path: <linux-kernel-owner+w=401wt.eu-S933318AbZJLVuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318AbZJLVuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZJLVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:50:51 -0400
Received: from radagast.issp.eu ([86.59.99.45]:45313 "EHLO radagast.issp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758414AbZJLVuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:50:50 -0400
Message-ID: <20091012235013.16174ciovvwpw70g@www.kundendienste.net>
Date: Mon, 12 Oct 2009 23:50:13 +0200
From: lkml@makubi.at
To: arndbergmann@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: DHCP and iptables
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

Well, I just looked for "ethernet protocol" and read some things about  
DHCP again.

What's an ethernet protocol?

I also read, that "DHCP is built directly on UDP and IP" (RFC 2131).

It uses Ports (UDP 67/68) and the source address of the DHCP server is  
an IP address.

Could you answer me more in detail, why I get an IP, but block  
everything with iptables?

Sincerely yours Mathias Kub

--------------------
12.10.2009 Mathias Kub <lkml@makubi.at>

|   Thank you very much for that quick reply.
|
|   Yours Mathias Kub
|
|   --------------------
|   12.10.2009 Arnd Bergmann <arndbergmann@googlemail.com>
|
|   |   On Monday 12 October 2009, lkml@makubi.at wrote:
|   |   > The last few days I have been wondering about the fact, that I get
|   |   > an IP address via
|   |   > DHCP if all chains at iptables are set to drop and no accept rules
|   |   > set.
|   |   >
|   |   > Does this happen on purpose?
|   |
|   |   DHCP is an ethernet protocol, not an IP protocol, so you have to use
|   |   ebtables instead of iptables to filter it.
|   |
|   |   	Arnd <><
|
|   --
|   To unsubscribe from this list: send the line "unsubscribe linux-kernel"
|    in the body of a message to majordomo@vger.kernel.org
|   More majordomo info at  http://vger.kernel.org/majordomo-info.html
|   Please read the FAQ at  http://www.tux.org/lkml/
|

