Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZKFSYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZKFSYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZKFSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:24:51 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63971 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZKFSYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:24:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a1sMGEoPgnkSePtQpdBVCHTBYDJDIaH2r8NglWalIwjNKrF1dJn8keIRexRc4FG37X
         oTkMeSLh9Wm8M80qXIS8YxPs73NhrpfPzzVQTd7qzDoZtA9c66D1PqXxrp3hxD7gdEqC
         6V0OnZuX0Xtr1eK/uIGSR721XXWJkSXQetL44=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 35/41] rt2800: prepare for rt2800lib addition
Date: Fri, 6 Nov 2009 19:24:52 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173617.28463.6733.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173617.28463.6733.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911061924.52696.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> @@ -2644,6 +2658,8 @@ static int rt2800usb_probe_hw(struct rt2
>  {
>  	int retval;
>  
> +	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
> +
>  	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
>  
>  	/*
> 

Another afterthought, so perhaps you could make it an incremental patch.
Could you move the rt2x00_set_chip_intf() to rt2x00pci and rt2x00usb?
That way the field will be set automatically for all drivers early during probe.

Thanks,

Ivo
