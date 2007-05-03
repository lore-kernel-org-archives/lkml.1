Return-Path: <linux-kernel-owner+w=401wt.eu-S1161791AbXECK1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161791AbXECK1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161785AbXECK1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:27:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45927
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161140AbXECK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:27:13 -0400
Date: Thu, 03 May 2007 03:27:14 -0700 (PDT)
Message-Id: <20070503.032714.11077929.davem@davemloft.net>
To: dhowells@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH 1/5] [NETLINK]: Fix use after free in netlink_recvmsg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 03 May 2007 10:53:15 +0100

> When the user passes in MSG_TRUNC the skb is used after getting freed.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: David Howells <dhowells@redhat.com>

Ugh, good catch, applied :-)
