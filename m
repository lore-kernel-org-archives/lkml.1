Return-Path: <linux-kernel-owner+w=401wt.eu-S1031200AbXECMc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031200AbXECMc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031195AbXECMcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:32:25 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:33648 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031191AbXECMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:32:24 -0400
Subject: Re: [PATCH 1/5] [NETLINK]: Fix use after free in netlink_recvmsg
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, kaber@trash.net
In-Reply-To: <20070503.032714.11077929.davem@davemloft.net>
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>
	 <20070503.032714.11077929.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 03 May 2007 14:27:16 +0200
Message-Id: <1178195236.6891.58.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > When the user passes in MSG_TRUNC the skb is used after getting freed.
> > 
> > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Ugh, good catch, applied :-)

it seems this could be easily exploited and is at least a local DoS. It
should be a candidate for the -stable kernel.

Regards

Marcel


