Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYKYT6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYKYT6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKYT6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:58:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49156 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752141AbYKYT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:58:04 -0500
Date: Tue, 25 Nov 2008 19:57:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [BUILD_FAILURE] linux-next: 20081125 - 8390 network driver
 build fails
Message-ID: <20081125195756.12317499@lxorguk.ukuu.org.uk>
In-Reply-To: <492C562E.9090302@oracle.com>
References: <20081125213738.881b425e.sfr@canb.auug.org.au>
	<20081125182542.GA4914@linux.vnet.ibm.com>
	<492C464D.4080704@oracle.com>
	<20081125185154.2845e8f1@lxorguk.ukuu.org.uk>
	<492C5334.2090801@oracle.com>
	<20081125193853.076c7b58@lxorguk.ukuu.org.uk>
	<492C562E.9090302@oracle.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/net/8390p.o: In function `ei_get_stats':
> (.text+0x1050): multiple definition of `ei_get_stats'
> drivers/net/8390.o:(.text+0xe20): first defined here
> drivers/net/8390p.o: In function `ei_start_xmit':
> (.text+0x1100): multiple definition of `ei_start_xmit'
> drivers/net/8390.o:(.text+0xef0): first defined here
> drivers/net/8390p.o: In function `ei_tx_timeout':
> (.text+0xec0): multiple definition of `ei_tx_timeout'
> drivers/net/8390.o:(.text+0xce0): first defined here
> drivers/net/8390p.o: In function `ei_set_multicast_list':
> (.text+0x1000): multiple definition of `ei_set_multicast_list'
> drivers/net/8390.o:(.text+0xea0): first defined here
> make[2]: *** [drivers/net/built-in.o] Error 1
> 
> and none of these functions is static in lib8390.c.

They seem to be just fine in the base tree, so somebody has merged
something stoopid.


 */

static int ei_start_xmit(struct sk_buff *skb, struct net_device *dev)  
{
   


Alan
