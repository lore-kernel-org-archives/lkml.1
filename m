Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbXBCTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbXBCTFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXBCTFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:05:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39125 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXBCTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:05:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45C4DC97.3050101@s5r6.in-berlin.de>
Date: Sat, 03 Feb 2007 20:03:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: cycle timer read extension for raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de> <45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> +++ linux/drivers/ieee1394/raw1394.h	2007-02-03 13:47:34.000000000 +0100
> @@ -178,4 +178,14 @@ struct raw1394_iso_status {
>  	__s16 xmit_cycle;
>  };
>  
> +/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> +struct raw1394_cycle_timer {
> +	/* contents of Isochronous Cycle Timer register,
> +	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
> +	__u32 cycle_timer;
> +
> +	/* local time in microseconds since Epoch,
> +	   simultaneously read with cycle timer */
> +	__u64 local_time;
> +};
>  #endif /* IEEE1394_RAW1394_H */

Pieter,
one more thing. Do you want to hand out the cycle_timer bitfield to
userspace as-is, or would it make sense to postprocess it in some way?
-- 
Stefan Richter
-=====-=-=== --=- ---==
http://arcgraph.de/sr/
