Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXHYEFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXHYEFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbXHYEFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:05:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20427 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXHYEFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:05:30 -0400
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
From: Daniel Walker <dwalker@mvista.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1188013483.2641.8.camel@lov.localdomain>
References: <20070824224707.GA7275@Krystal>
	 <20070824161029.6236a5f4.akpm@linux-foundation.org>
	 <20070825001638.GB9811@Krystal>
	 <20070824174450.70337f4f.akpm@linux-foundation.org>
	 <20070825004640.GA21756@kroah.com>  <20070825030251.GA15827@Krystal>
	 <1188013483.2641.8.camel@lov.localdomain>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 20:58:32 -0700
Message-Id: <1188014312.2435.160.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-25 at 05:44 +0200, Kay Sievers wrote:

> --- a/drivers/firmware/dmi-id.c
> +++ b/drivers/firmware/dmi-id.c
> @@ -155,6 +155,7 @@ static int dmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
>  			   sizeof(env->buf) - env->buflen);
>  	if (len >= (sizeof(env->buf) - env->buflen))
>  		return -ENOMEM;
> +	env->buflen += len;
>  	return 0;
>  }
>  

Works for me too ..

Daniel

