Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbYDLJM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbYDLJM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbYDLJMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:12:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432AbYDLJMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:12:16 -0400
Message-ID: <48007CED.5030601@garzik.org>
Date: Sat, 12 Apr 2008 05:12:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain> <m3tzj92xq6.fsf@maximus.localdomain>
In-Reply-To: <m3tzj92xq6.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> New synchronous PPP implementation for generic HDLC.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
> 
>  drivers/net/wan/Makefile   |    2 +-
>  drivers/net/wan/hdlc_ppp.c |  649 ++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 602 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
> index d61fef3..3081683 100644
> --- a/drivers/net/wan/Makefile
> +++ b/drivers/net/wan/Makefile
> @@ -14,7 +14,7 @@ obj-$(CONFIG_HDLC_RAW)		+= hdlc_raw.o
>  obj-$(CONFIG_HDLC_RAW_ETH)	+= hdlc_raw_eth.o
>  obj-$(CONFIG_HDLC_CISCO)	+= hdlc_cisco.o
>  obj-$(CONFIG_HDLC_FR)		+= hdlc_fr.o
> -obj-$(CONFIG_HDLC_PPP)		+= hdlc_ppp.o	syncppp.o
> +obj-$(CONFIG_HDLC_PPP)		+= hdlc_ppp.o
>  obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o

applied


