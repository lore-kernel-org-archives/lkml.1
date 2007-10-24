Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXJXTIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXJXTIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbXJXTIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:08:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36618 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbXJXTIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:08:09 -0400
In-Reply-To: <20071024162410.GE30533@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [2.6 patch] unexport icmpmsg_statistics
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFD68B1480.9D9C7453-ON8825737E.0068B005-8825737E.0068FB84@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 24 Oct 2007 12:07:45 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 10/24/2007 13:07:53,
	Serialize complete at 10/24/2007 13:07:53
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

netdev-owner@vger.kernel.org wrote on 10/24/2007 09:24:10 AM:

> This patch removes the unused EXPORT_SYMBOL(icmpmsg_statistics).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 4ce74657ac0b1bdcb4c7bc359d05643f8cc4a08b 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 272c69e..233de06 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -1104,5 +1104,4 @@ void __init icmp_init(struct net_proto_family 
*ops)
>  EXPORT_SYMBOL(icmp_err_convert);
>  EXPORT_SYMBOL(icmp_send);
>  EXPORT_SYMBOL(icmp_statistics);
> -EXPORT_SYMBOL(icmpmsg_statistics);
>  EXPORT_SYMBOL(xrlim_allow);

        "icmpmsg_statistics" belongs with (and replaces some of the 
old...)
"icmp_statistics". I'm not sure that any modules use it, but I think you
should remove both or neither.

                                                                +-DLS


