Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbXJORvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbXJORvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757480AbXJORvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:51:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:23299 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbXJORvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=jvZQ83UZTyxldTiNlcOQHp/MJjsc71wPADDIXPU9iifHCU63mmCHPEkQkHDDGUbWOXR4kZZNRMzKYnYIP8AtE1zO+qth489aISZ6M1o8+qlY249Zh7haVOrNHCXhpnQubqkJotW5OCTT7QkeIhFJTeJkI1Ztuu89wJYiDAFTl/U=
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] jiffies_round -> jiffies_round_relative conversion - rt2x00
Date: Mon, 15 Oct 2007 20:08:32 +0200
User-Agent: KMail/1.9.7
Cc: Anton Blanchard <anton@samba.org>, linux-wireless@vger.kernel.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
References: <20071015053428.GA3257@kryten> <20071015053801.GB3257@kryten> <20071015054034.GC3257@kryten>
In-Reply-To: <20071015054034.GC3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152008.32503.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007, Anton Blanchard wrote:
> 
> When rounding a relative timeout we need to use round_jiffies_relative(). 
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 298faa9..06d9bc0 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -30,7 +30,7 @@
>   * Interval defines
>   * Both the link tuner as the rfkill will be called once per second.
>   */
> -#define LINK_TUNE_INTERVAL	( round_jiffies(HZ) )
> +#define LINK_TUNE_INTERVAL	( round_jiffies_relative(HZ) )
>  #define RFKILL_POLL_INTERVAL	( 1000 )
>  
>  /*
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
> 


