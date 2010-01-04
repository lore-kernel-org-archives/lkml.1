Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411Ab0ADNwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0ADNwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026Ab0ADNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:52:21 -0500
Received: from stinky.trash.net ([213.144.137.162]:34412 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0ADNwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:52:20 -0500
Message-ID: <4B41F292.8080908@trash.net>
Date: Mon, 04 Jan 2010 14:52:18 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Milan Dadok <milan@dadok.name>
CC: uaca@alumni.uv.es, johann.baudy@gnu-log.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] 1/1 net: packet: Keep 802.1Q VLAN tag in packet on SOCK_DGRAM
 socket - resend
References: <001801ca8d1d$90c68de0$b253a9a0$@name>
In-Reply-To: <001801ca8d1d$90c68de0$b253a9a0$@name>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please don't remove the mailing list from CC]

Milan Dadok wrote:
> Keep 802.1Q VLAN tag on non HW vlan accelerated network card received to SOCK_DGRAM socket.

Quoting from Documentation/networking/packet_mmap.txt:

fd= socket(PF_PACKET, mode, htons(ETH_P_ALL))

where mode is SOCK_RAW for the raw interface were link level
information can be captured or SOCK_DGRAM for the cooked
interface where link level information capture is not
supported and a link level pseudo-header is provided
by the kernel.

So not including the link layer header for SOCK_DGRAM sockets
seems to be the intended behaviour.
