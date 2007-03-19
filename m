Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbXCSTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbXCSTT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXCSTT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:19:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38772
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbXCSTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:19:58 -0400
Date: Mon, 19 Mar 2007 12:19:58 -0700 (PDT)
Message-Id: <20070319.121958.48807741.davem@davemloft.net>
To: dhowells@redhat.com
Cc: alan@lxorguk.ukuu.org.uk, mrmacman_g4@mac.com, netdev@vger.kernel.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org, hch@infradead.org,
       arjan@infradead.org
Subject: Re: [PATCH 0/5] [RFC] AF_RXRPC socket family implementation [try
 #2] 
From: David Miller <davem@davemloft.net>
In-Reply-To: <25752.1174318898@redhat.com>
References: <2578.1174305403@redhat.com>
	<3728.1174309154@redhat.com>
	<25752.1174318898@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 19 Mar 2007 15:41:38 +0000

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > So use SOCK_DGRAM, its clearly near enough.
> 
> No, it's not.  SOCK_DGRAM is an unreliable, unidirectional datagram passing
> service.

David we're not looking for a precise match, so please stop
discussing this in those terms.  We're looking for something
close enough.

The more and more I read Alan's arguments and your resistence to
his logic, the more I side with Alan.  He's definitely right on
all the basic counts here.
