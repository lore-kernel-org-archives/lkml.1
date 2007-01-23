Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXAWLMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXAWLMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 06:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932971AbXAWLMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 06:12:52 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:34603 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857AbXAWLMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 06:12:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P9KfjJgMwwbVpSMp88kfmVPZXDeMPdTviu+vlA80Q7+ko1BqurMXY7LRT2W9yfDHlWupTMdB2Kp8gUJSRnS8vGBgdq0TbzLJWdSO7HNiTmhKxA0u9lpQvq5TJFGic0gJlJZIR8agXD3aD9hO7VNTnBrvQgcsJiqVpbLZ1hwNaBw=
Message-ID: <f4527be0701230312q2a22b41i93abdf8972525d9e@mail.gmail.com>
Date: Tue, 23 Jan 2007 11:12:50 +0000
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.19.2 sky2/acpi crashes
In-Reply-To: <ep4nb2$mh2$1@fortknox.intranet.wo.rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1169542768.5537.11.camel@cocoduo>
	 <ep4nb2$mh2$1@fortknox.intranet.wo.rk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
> On Tue, 23 Jan 2007 08:59:28 +0000, Lionel Landwerlin wrote:
>
> > Hi,
> >
> > I'm running a macbook with a Marvell ethernet controller, and I have a
> > lots of freezes when using the ethernet controller under a load of
> > ~100K/s. Since I'm running a 2.6.19.2 kernel, I'm able to get some
> > report from the kernel. Here they are :
>
> I am also having trouble with the sky2 module, though I've not yet seen a
> oops, the driver stopped working after some heavy traffic (copying some G
> of data). Only rmmod sky2; modprobe sky2 resolved this. (I am also on
> 2.6.19.2 but I've seen this happen on 2.6.20-rcX too).
>
> Soeren
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Ive also had the same problem with both 2.6.19.2 and 2.6.20-rcX,
motherboard is gigabyte ga-965-ds3 , the networking stops completely
under moderate traffic, I get the following errors or a complete
lockup:

Jan 21 02:08:04 beast NETDEV WATCHDOG: eth0: transmit timed out
Jan 21 02:08:04 beast sky2 eth0: tx timeout
Jan 21 02:08:04 beast sky2 eth0: transmit ring 475 .. 452 report=475 done=475
Jan 21 02:08:04 beast sky2 hardware hung? flushing

At the time I was downloading a iso image at 850k/sec, so not really a
high network load at all.

rmmod / modprobe does resolve the issue, but more times than not the
box locks up completely instead of getting those errors.

Andy
