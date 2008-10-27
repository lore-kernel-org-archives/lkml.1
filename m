Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbYJ0X43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbYJ0X43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJ0X4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:56:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49632
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYJ0X4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:56:19 -0400
Date: Mon, 27 Oct 2008 16:55:56 -0700 (PDT)
Message-Id: <20081027.165556.30975206.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3] printk: add %pM format specifier for MAC
 addresses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225149254.6339.4.camel@brick>
References: <1225137542.5396.10.camel@brick>
	<20081027.154736.178482850.davem@davemloft.net>
	<1225149254.6339.4.camel@brick>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 27 Oct 2008 16:14:14 -0700

> Did you happen to have a preference with regard to the specifier for
> IPv6 addresses:
> 
> I was thinking of using %pI6 to replace NIP6() and NIP6_FMT and using
> %#pI6 for NIP6_SEQFMT.
> 
> On the IPv4 side, maybe use %pI4 for network endian NIPQUAD() and NIPQUAD_FMT
> and then %#pI4 for host-endian HIQUAD(), as displaying the IPv4 address without
> the periods isn't useful?
> 
> What do you think of that?

I'm ok with the '#' modifier but remind me again what's wrong with
using plain %p4 and %p6?
