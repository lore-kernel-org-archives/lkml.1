Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbYCENHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbYCENHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761512AbYCENHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:07:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44003 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761505AbYCENHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:07:10 -0500
Message-ID: <47CE9AF9.6070200@garzik.org>
Date: Wed, 05 Mar 2008 08:07:05 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] net: replace __inline with inline
References: <1204679838.5698.70.camel@brick>
In-Reply-To: <1204679838.5698.70.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/net/wan/sbni.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
> index 15d5c58..e59255a 100644
> --- a/drivers/net/wan/sbni.c
> +++ b/drivers/net/wan/sbni.c
> @@ -751,7 +751,7 @@ upload_data( struct net_device  *dev,  unsigned  framelen,  unsigned  frameno,
>  }
>  
> 
> -static __inline void
> +static inline void
>  send_complete( struct net_local  *nl )
>  {

better to remove the inline altogether, and let the compiler make the 
decision on its own...


