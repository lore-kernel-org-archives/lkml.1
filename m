Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXCPOKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXCPOKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933916AbXCPOKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:10:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933257AbXCPOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:10:10 -0400
Date: Fri, 16 Mar 2007 15:13:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org,
       dhowells@redhat.com
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #2]
Message-ID: <20070316151305.04cbc352@lxorguk.ukuu.org.uk>
In-Reply-To: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
References: <20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Sockets of AF_RXRPC family are:
> 
>  (1) created as type SOCK_RPC;

There is no such socket type and please don't invent one

If your messages are datagrams and unreliable -> SOCK_DGRAM
If your messages are datagrams and reliable -> SOCK_RDM
If your messages are datagrams, reliable and ordered -> SOCK_SEQPACKET
If your messages are streams of bits, reliable and ordered -> SOCK_STREAM


