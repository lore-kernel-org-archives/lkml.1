Return-Path: <linux-kernel-owner+w=401wt.eu-S1161881AbXECMsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161881AbXECMsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161880AbXECMsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:48:05 -0400
Received: from stinky.trash.net ([213.144.137.162]:61688 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161874AbXECMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:48:03 -0400
Message-ID: <4639D9A5.3060401@trash.net>
Date: Thu, 03 May 2007 14:46:29 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: David Miller <davem@davemloft.net>, dhowells@redhat.com, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] [NETLINK]: Fix use after free in netlink_recvmsg
References: <20070503095315.26912.24270.stgit@warthog.cambridge.redhat.com>	 <20070503.032714.11077929.davem@davemloft.net> <1178195236.6891.58.camel@violet>
In-Reply-To: <1178195236.6891.58.camel@violet>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> it seems this could be easily exploited and is at least a local DoS. It
> should be a candidate for the -stable kernel.


The bug got introduced in 2.6.21-git, so -stable is not affected.
