Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbXEVXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbXEVXOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756935AbXEVXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:13:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44041
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756912AbXEVXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:13:55 -0400
Date: Tue, 22 May 2007 16:13:58 -0700 (PDT)
Message-Id: <20070522.161358.45179068.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, netdeg@vger.kernel.org
Subject: Re: [PATCH 1/2] AF_RXRPC: AF_RXRPC depends on IPv4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
References: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 22 May 2007 13:56:05 +0100

> Add a dependency for CONFIG_AF_RXRPC on CONFIG_INET.  This fixes this error:
> 
> net/built-in.o: In function `rxrpc_get_peer':
> (.text+0x42824): undefined reference to `ip_route_output_key'
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
