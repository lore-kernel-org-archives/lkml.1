Return-Path: <linux-kernel-owner+w=401wt.eu-S936637AbXLQWm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936637AbXLQWm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXLQWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:42:46 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3644 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXLQWmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:42:45 -0500
Subject: Re: [PATCH net-2.6.25 1/8] Create ipv4_is_<type>(__be32 addr)
	functions
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
References: <1197589141-7020-1-git-send-email-joe@perches.com>
	 <Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 14:42:41 -0800
Message-Id: <1197931361.27386.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 23:37 +0100, Jan Engelhardt wrote:
> >+static inline bool ipv4_is_loopback(__be32 addr)
> >+{
> >+	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
> >+}
> >+
> Can we use __constant_htonl()?

I believe the generated code is the same.

> >+static inline bool ipv4_is_private_10(__be32 addr)
> >+{
> >+	return (addr & htonl(0xff000000)) == htonl(0x0a000000);
> >+}
> 
> What are these functions needed for, even? There does not seem to be
> any code (at least in davem's net-2.6.25:net/ipv4/, where I dared to grep)
> that uses them.

include/net/addrconf.h
net/sctp/protocol.c

cheers, Joe

