Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737Ab0AKKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab0AKKvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 05:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496Ab0AKKvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 05:51:51 -0500
Received: from stinky.trash.net ([213.144.137.162]:59879 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0AKKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 05:51:50 -0500
Message-ID: <4B4B02BE.5060209@trash.net>
Date: Mon, 11 Jan 2010 11:51:42 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
       James Morris <jmorris@namei.org>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/8] net/ipv4/netfilter/nf_nat_ftp.c: Remove (*mangle[])
 array and functions, use %pI4
References: <cover.1262726222.git.joe@perches.com>	 <bccf36219f3ea5a9b7565734bc87095bc986dbe0.1262726222.git.joe@perches.com> <1262805798.1952.105.camel@Joe-Laptop.home>
In-Reply-To: <1262805798.1952.105.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> These functions merely exist to format a buffer and call
> nf_nat_mangle_tcp_packet.
> 
> Format the buffer and perform the call in nf_nat_ftp instead.
> 
> Use %pI4 for the IP address.
> 
> Saves ~600 bytes of text
> 
> old:
> $ size net/ipv4/netfilter/nf_nat_ftp.o
>    text	   data	    bss	    dec	    hex	filename
>    2187	    160	    408	   2755	    ac3	net/ipv4/netfilter/nf_nat_ftp.o
> new:
> $ size net/ipv4/netfilter/nf_nat_ftp.o
>    text    data     bss     dec     hex filename
>    1532     112     288    1932     78c net/ipv4/netfilter/nf_nat_ftp.o

Applied, thanks. BTW, its enough to CC netfilter-devel and optionally
netdev on patches, netfilter and netfilter-core are unnecessary.

