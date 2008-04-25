Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYDYGCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYDYGCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 02:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbYDYGCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 02:02:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58467 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbYDYGCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 02:02:01 -0400
Message-ID: <481173D6.6080609@garzik.org>
Date: Fri, 25 Apr 2008 02:01:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Removing dead code in /drivers/net/wan/hdlc_fr.c
References: <m3lk385tx4.fsf@maximus.localdomain>
In-Reply-To: <m3lk385tx4.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> From: Cédric Augonnet <Cedric.Augonnet@ens-lyon.fr>
> 
> Removing dead code in /drivers/net/wan/hdlc_fr.c
>     
> The local variable "prefix" is never used anymore, and the content of
> this string appears a bit later, directly in a call to "alloc_netdev"
> after doing exactly the same if/else test. So there seems to be no
> point keeping those 4 lines anymore.
>     
> Signed-off-by: Cédric Augonnet <cedric.augonnet@ens-lyon.org>
> Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index c4ab032..520bb0b 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -1090,10 +1090,6 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
>  	pvc_device *pvc = NULL;
>  	struct net_device *dev;
>  	int result, used;
> -	char * prefix = "pvc%d";
> -
> -	if (type == ARPHRD_ETHER)
> -		prefix = "pvceth%d";
>  
>  	if ((pvc = add_pvc(frad, dlci)) == NULL) {

applied


