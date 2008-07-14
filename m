Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYGNQnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYGNQnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYGNQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:43:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:40360 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYGNQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:43:05 -0400
Message-ID: <487B820E.4020002@mellanox.co.il>
Date: Mon, 14 Jul 2008 19:42:54 +0300
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] ***SPAM*** InfiniBand/RDMA merge plans for 2.6.27
References: <ada8ww5jbaf.fsf@cisco.com>
In-Reply-To: <ada8ww5jbaf.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Core:
>
>  - I'm waiting to merge the RDMA_CM_EVENT_ADDR_CHANGE changes that
>    depend on core networking changes until such changes are upstream.
>    Or, please remind me when that happens.
>
>  - Jack's XRC patch set.  I think we're getting closer to converging
>    here, and I hope to get this merged but we're getting down to the
>    wire, so we'll see.
>   
I hope we can get those in
> HW specific:
>
>  - Yevgeny's mlx4 changes.  We'll see how much time is left after I
>    get done with XRC (which is before this on my list) but to be
>    honest I'm not sure how mergeable a lot of this is without the
>    mlx4_en patches that actually use it.
>   
We just posted the mlx4_en patches, and we need to coordinate the merge 
of them together
>  - I've been working on memory management extensions support for mlx4,
>    but I'm not sure if it will be ready in time.  Firmware for this
>    may not be released for a while so it ain't urgent anyway.
>   
We are testing the patches and we already have FW that enable them.
I agree its not urgent but it would be good to have it, so ULPs that are 
interested can be tested over IB too.
> Here are a few topics that I believe will not be ready in time for the
> 2.6.27 window and will need to wait for 2.6.28 at least:
>
>  - Multiple CQ event vector support.  No one has convinced me that we
>    know how ULPs or userspace apps should decide which vector to use,
>    and hence little progress has been made since we deferred this
>    during the 2.6.23 merge window.
>   
We should progress this one even if we missed 2.6.27, especially we need 
it for RSS, and I know also RDS can gain from it.

Tziporet
