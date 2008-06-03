Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbYFCWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbYFCWAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFCWAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:00:43 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40831 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbYFCWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:00:40 -0400
Message-ID: <4845BF11.7070604@lwfinger.net>
Date: Tue, 03 Jun 2008 17:00:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
       mokuno@sm.sony.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12]: wext: Emit event stream entries correctly when
 compat.
References: <20080603.132856.202640855.davem@davemloft.net>
In-Reply-To: <20080603.132856.202640855.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> Three major portions to this change:
> 
> 1) Add IW_EV_COMPAT_LCP_LEN, IW_EV_COMPAT_POINT_OFF,
>    and IW_EV_COMPAT_POINT_LEN helper defines.
> 
> 2) Delete iw_stream_check_add_*(), they are unused.
> 
> 3) Add iw_request_info argument to iwe_stream_add_*(), and use it to
>    size the event and pointer lengths correctly depending upon whether
>    IW_REQUEST_FLAG_COMPAT is set or not.
> 
> 4) The mechanical transformations to the drivers and wireless stack
>    bits to get the iw_request_info passed down into the routines
>    modified in #3.
> 
> With a lot of help and bug fixes from Masakazu Mokuno.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---

David,

What tree should be used for this patch? On wireless-testing that 
git-describe lists as v2.6.26-rc4-8782-gd9a8bd7, hunk 5 for mlme.c fails.

Larry

