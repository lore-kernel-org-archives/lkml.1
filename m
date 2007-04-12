Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXDLOok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXDLOok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992551AbXDLOok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:44:40 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:20354 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992546AbXDLOoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:44:39 -0400
Message-ID: <461E45C3.2050400@chelsio.com>
Date: Thu, 12 Apr 2007 07:44:19 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Steve Wise <swise@opengridcomputing.com>
CC: Roland Dreier <rdreier@cisco.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.21] iw_cxgb3 - Add set_tcb_rpl_handler.
References: <1176382594.9396.1.camel@stevo-desktop>
In-Reply-To: <1176382594.9396.1.camel@stevo-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Apr 2007 14:44:22.0635 (UTC) FILETIME=[0F344BB0:01C77D11]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Wise wrote:
> Hey Roland,
>
> This patch is needed for iw_cxgb3 to handle a change in the cxgb3 driver
> posted by Divy that Jeff recently applied.  If the cxgb3 change is
> destined for 2.6.21, then this change to iw_cxgb3 also needs to go in
> (otherwise we get an error log entry for every rdma connection).  
>
> It was an oversight that this patch didn't really get included in Divy's
> series since the two go together.
>
> See http://marc.info/?l=linux-netdev&m=117617444422260&w=2
>
>
> Thanks,
>
> Steve.
>
>
> ---
>
>
> Add set_tcb_rpl_handler.
>
> The Ethernet Driver no longer handles SET_TCB replies.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
>   
Acked-by: Divy Le Ray <divy@chelsio.com>
