Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYEaB6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYEaB6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbYEaB6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:58:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbYEaB6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:58:39 -0400
Message-ID: <4840B0C5.4020606@pobox.com>
Date: Fri, 30 May 2008 21:58:29 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5 of 5] xen: Avoid allocations causing swap activity on
 the	resume path
References: <c692f3a12da1e99a4a43.1212192095@localhost>
In-Reply-To: <c692f3a12da1e99a4a43.1212192095@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Ian Campbell <ian.campbell@citrix.com>
> 
> Avoid allocations causing swap activity on the resume path by allowing
> such allocations to access the emergency pools otherwise a
> save/restore/migration of a guest which is low on memory can
> deadlock.
> 
> [ linux-2.6.18-xen changesets e8b49cfbdac, fdb998e79aba ]
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> ---
>  drivers/block/xen-blkfront.c       |    5 +++--
>  drivers/net/xen-netfront.c         |    4 ++--
>  drivers/xen/xenbus/xenbus_client.c |    2 +-
>  drivers/xen/xenbus/xenbus_xs.c     |   10 +++++-----
>  4 files changed, 11 insertions(+), 10 deletions(-)

IMO I am not qualified enough to ACK or NAK this VM-related patch...  If 
others are happy with it, go ahead and merge the xen-netfront.c with 
that batch.




