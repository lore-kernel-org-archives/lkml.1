Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXLMCAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXLMCAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 21:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXLMCAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 21:00:25 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35136 "EHLO
	outbound8-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbXLMCAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 21:00:24 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4760922C.2060908@am.sony.com>
Date: Wed, 12 Dec 2007 18:00:12 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Daniel Walker <dwalker@mvista.com>, matthias.kaehlcke@gmail.com,
       linux-kernel@vger.kernel.org, linux@bohmer.net, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, kjwinchester@gmail.com
Subject: Re: [PATCH 1/3] ps3: vuart: fix error path locking
References: <20071213003028.676998182@mvista.com>
In-Reply-To: <20071213003028.676998182@mvista.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2007 02:00:16.0851 (UTC) FILETIME=[E8319230:01C83D2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This stray down would cause a permanent sleep which doesn't seem correct. 
> The other uses of this semaphore appear fairly mutex like it's even initialized
> with init_MUTEX() ..  So here a patch for removing this one down().
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  drivers/ps3/ps3-vuart.c |    1 -
>  1 file changed, 1 deletion(-)


Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>


Looks, good. 
Andrew, Please apply.

-Geoff 



