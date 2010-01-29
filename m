Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558Ab0A2Crz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab0A2Crz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246Ab0A2Crz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:47:55 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:58264 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab0A2Cry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:cc:subject
	:references:from:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=tOUhrnV3rnL1FaBsgJwGRyh7tM0ic8zP
	+n3whF4yseJ0UNS0APsQgQlVHqYm7eWXq42g24WhU1MKJRcxOBsIFt/rIR5Z5gfU
	hnuH8iHBSXSUm0+KzvuxifOpFUCQFxesqG/mxKPEqE2BPcPIMrtqVDuzPkY9ylvQ
	M7JPx3/yam0=
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] tree-wide: trivial typo fixes: s/lenght/length/g
References: <alpine.LNX.2.00.1001282357190.356@pobox.suse.cz>
 <1264730438-2218-1-git-send-email-daniel@caiaq.de>
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 28 Jan 2010 18:47:44 -0800
In-Reply-To: <1264730438-2218-1-git-send-email-daniel@caiaq.de> (Daniel
 Mack's message of "Fri\, 29 Jan 2010 10\:00\:38 +0800")
Message-ID: <7vy6jhk4of.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: B057162E-0C80-11DF-9268-6AF7ED7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <daniel@caiaq.de> writes:

> diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
> index 2282e72..fba9145 100644
> --- a/drivers/net/ppp_generic.c
> +++ b/drivers/net/ppp_generic.c
> @@ -1437,7 +1437,7 @@ static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb)
>  
>  		/*
>  		 *check	if we are on the last channel or
> -		 *we exceded the lenght	of the data	to
> +		 *we exceded the length	of the data	to
>  		 *fragment
>  		 */

How about inserting an SP after asterisks while you are at it?

> diff --git a/drivers/net/stmmac/gmac.c b/drivers/net/stmmac/gmac.c
> index 52586ee..467dc46 100644
> --- a/drivers/net/stmmac/gmac.c
> +++ b/drivers/net/stmmac/gmac.c
> @@ -257,7 +257,7 @@ static int gmac_coe_rdes0(int ipc_err, int type, int payload_err)
>  
>  	/* bits 5 7 0 | Frame status
>  	 * ----------------------------------------------------------
> -	 *      0 0 0 | IEEE 802.3 Type frame (lenght < 1536 octects)
> +	 *      0 0 0 | IEEE 802.3 Type frame (length < 1536 octects)

"octets"?
