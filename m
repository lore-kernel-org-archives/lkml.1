Return-Path: <linux-kernel-owner+w=401wt.eu-S965181AbXCPObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbXCPObR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXCPObR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:31:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42745 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965181AbXCPObO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:31:14 -0400
Date: Fri, 16 Mar 2007 15:34:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, herbert.xu@redhat.com,
       linux-kernel@vger.kernel.org, hch@infradead.org, arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #2]
Message-ID: <20070316153408.3a9a244a@lxorguk.ukuu.org.uk>
In-Reply-To: <25571.1174054993@redhat.com>
References: <20070316151305.04cbc352@lxorguk.ukuu.org.uk>
	<20070316125008.3740.44693.stgit@warthog.cambridge.redhat.com>
	<25571.1174054993@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 14:23:13 +0000
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > If your messages are datagrams and unreliable -> SOCK_DGRAM
> 
> Nope.
> 
> > If your messages are datagrams and reliable -> SOCK_RDM
> 
> Nope.
> 
> > If your messages are datagrams, reliable and ordered -> SOCK_SEQPACKET
> 
> Nope.
> 
> > If your messages are streams of bits, reliable and ordered -> SOCK_STREAM
> 
> Nope.

So your messages are neither reliable not unreliable, nor ordered, nor
unordered.

NAK

Until you work out what your messages actually are and use a proper
standard socket type. And "but there are higher layers" isn't relevant
here, this is true for Appletalk as well and it doesn't have to go
inventing new types for everything as you seem to.

Alan
