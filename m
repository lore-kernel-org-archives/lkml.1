Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXECULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXECULk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXECULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:11:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54877
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbXECULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:11:38 -0400
Date: Thu, 03 May 2007 13:11:39 -0700 (PDT)
Message-Id: <20070503.131139.66310255.davem@davemloft.net>
To: marcel@holtmann.org
Cc: dhowells@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH 1/5] [NETLINK]: Fix use after free in netlink_recvmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <1178195236.6891.58.camel@violet>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
	<20070503.032714.11077929.davem@davemloft.net>
	<1178195236.6891.58.camel@violet>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Thu, 03 May 2007 14:27:16 +0200

> Hi Dave,
> 
> > > When the user passes in MSG_TRUNC the skb is used after getting freed.
> > > 
> > > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > 
> > Ugh, good catch, applied :-)
> 
> it seems this could be easily exploited and is at least a local DoS. It
> should be a candidate for the -stable kernel.

The MSG_TRUNC change is in 2.6.22 GIT only.

You might want to check such things before making such statements. :-/

