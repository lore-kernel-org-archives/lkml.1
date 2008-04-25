Return-Path: <linux-kernel-owner+w=401wt.eu-S1764666AbYDYX7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764666AbYDYX7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbYDYX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:59:03 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64062 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756011AbYDYX7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:59:01 -0400
Date: Sat, 26 Apr 2008 00:58:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Michael Beasley <youvegotmoxie@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typo in net/ipv6/Kconfig
In-Reply-To: <20080424103950.GA6723@snafu.setup>
Message-ID: <Pine.LNX.4.55.0804260053290.13902@cliff.in.clinika.pl>
References: <20080424103950.GA6723@snafu.setup>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Michael Beasley wrote:

> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index eb0b808..56b4d86 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
> @@ -172,7 +172,7 @@ config IPV6_SIT
>           Tunneling means encapsulating data of one protocol type within
>           another protocol and sending it over a channel that understands the
>           encapsulating protocol. This driver implements encapsulation of IPv6
> -         into IPv4 packets. This is useful if you want to connect two IPv6
> +         into IPv4 packets. This is useful if you want to connect to IPv6
>           networks over an IPv4-only path.
> 
>           Saying M here will produce a module called sit.ko. If unsure, say Y.
> 
> Two is used in the wrong context here, as you are connecting to an IPv6 network
> over IPv4; not connecting two IPv6 networks to an IPv4 one.

 NAK.  The text correctly describes the scenario.  You have two IPv6
networks, between which you set up a SIT tunnel which transmits data
between the two networks encapsulated in IPv4 packets.  If you find the
text not self-explanatory, then perhaps the sentence could be rewritten as
follows:

"This is useful if you want to connect two IPv6 networks to each other
over an IPv4-only path."

  Maciej
