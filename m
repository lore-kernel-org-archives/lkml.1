Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbXIWT0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbXIWT0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXIWT01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:26:27 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:45494 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXIWT01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:26:27 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 1/2 (v2)] cxacru: Use appropriate logging for errors
Date: Sun, 23 Sep 2007 21:26:22 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <46F68708.6070409@simon.arlott.org.uk> <200709231817.39076.duncan.sands@math.u-psud.fr> <46F6B3F1.80201@simon.arlott.org.uk>
In-Reply-To: <46F6B3F1.80201@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709232126.23341.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -		dbg("too big transfer requested");
> +		if (printk_ratelimit())
> +			usb_err(instance->usbatm, "requested transfer size too large (%d, %d)\n",
> +				wbuflen, rbuflen);

etc

Acked-by: Duncan Sands <baldrick@free.fr>
