Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbYDZAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbYDZAVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933390AbYDZASx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:18:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58168
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933665AbYDZASw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:18:52 -0400
Date: Fri, 25 Apr 2008 17:18:52 -0700 (PDT)
Message-Id: <20080425.171852.129256614.davem@davemloft.net>
To: macro@linux-mips.org
Cc: youvegotmoxie@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix typo in net/ipv6/Kconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.55.0804260053290.13902@cliff.in.clinika.pl>
References: <20080424103950.GA6723@snafu.setup>
	<Pine.LNX.4.55.0804260053290.13902@cliff.in.clinika.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Maciej W. Rozycki" <macro@linux-mips.org>
Date: Sat, 26 Apr 2008 00:58:49 +0100 (BST)

> On Thu, 24 Apr 2008, Michael Beasley wrote:
> 
> > diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> > index eb0b808..56b4d86 100644
> > --- a/net/ipv6/Kconfig
> > +++ b/net/ipv6/Kconfig
> > @@ -172,7 +172,7 @@ config IPV6_SIT
> >           Tunneling means encapsulating data of one protocol type within
> >           another protocol and sending it over a channel that understands the
> >           encapsulating protocol. This driver implements encapsulation of IPv6
> > -         into IPv4 packets. This is useful if you want to connect two IPv6
> > +         into IPv4 packets. This is useful if you want to connect to IPv6
> >           networks over an IPv4-only path.
> > 
> >           Saying M here will produce a module called sit.ko. If unsure, say Y.
> > 
> > Two is used in the wrong context here, as you are connecting to an IPv6 network
> > over IPv4; not connecting two IPv6 networks to an IPv4 one.
> 
>  NAK.  The text correctly describes the scenario.  You have two IPv6
> networks, between which you set up a SIT tunnel which transmits data
> between the two networks encapsulated in IPv4 packets.  If you find the
> text not self-explanatory, then perhaps the sentence could be rewritten as
> follows:
> 
> "This is useful if you want to connect two IPv6 networks to each other
> over an IPv4-only path."

This patch is already in Linus's tree, someone send me a revert
if they want it changed back.
