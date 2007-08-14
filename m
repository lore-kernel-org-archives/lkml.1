Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXHNX0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXHNX0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXHNXZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:25:37 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8583 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761181AbXHNXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:25:36 -0400
Message-ID: <46C239EC.7000505@chelsio.com>
Date: Tue, 14 Aug 2007 16:25:32 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 4/13] cxgb3 - use immediate data for offload Tx
References: <20070811062949.8076.42523.stgit@speedy5> <46C14106.4080604@garzik.org>
In-Reply-To: <46C14106.4080604@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Aug 2007 23:24:15.0618 (UTC) FILETIME=[3AE4C620:01C7DECA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> Divy Le Ray wrote:
> > From: Divy Le Ray <divy@chelsio.com>
> >
> > Send small TX_DATA work requests as immediate data even when
> > there are fragments.
> >
> > Signed-off-by: Divy Le Ray <divy@chelsio.com>
> > ---
> >
> >  drivers/net/cxgb3/sge.c |   17 +++++++++++------
> >  1 files changed, 11 insertions(+), 6 deletions(-)
>
> needs additional explanation.  don't just describe the new post-change
> behavior, describe why this change is needed.
>
>
It's an optimization avoiding doing multiple DMAs for small fragmented 
packets.
The driver already implements this optimization for small contiguous 
packets.

Divy
