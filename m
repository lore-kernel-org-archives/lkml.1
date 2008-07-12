Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYGLCpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYGLCpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 22:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGLCo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 22:44:58 -0400
Received: from userg501.nifty.com ([202.248.238.81]:64359 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYGLCo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 22:44:57 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=UAHglFEKYGbDAxEShOm6TsMAGODN3Al5pK5r6CXk0TUt092f44RnjztCrKD6OdpLg
	YlwGPe1KzKzPTwRhllB8Q==
X-Nifty-SrcIP: [220.145.29.110]
Date: Sat, 12 Jul 2008 11:39:16 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-ide@vger.kernel.org,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>, jgarzik@redhat.com,
       rjw@sisk.pl
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk
 Extreme III 8GB
Message-Id: <20080712113916.fb69df6b.komurojun-mbn@nifty.com>
In-Reply-To: <48743A1A.2010304@gmail.com>
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>
	<20080528222740.GB20893@isilmar.linta.de>
	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>
	<20080607223716.7d142072.komurojun-mbn@nifty.com>
	<20080611072029.GB28692@comet.dominikbrodowski.net>
	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>
	<48537149.4040102@garzik.org>
	<20080614213612.96873c25.komurojun-mbn@nifty.com>
	<4855D8E2.10409@gmail.com>
	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>
	<485669A0.6000404@gmail.com>
	<20080617212345.c452d8c5.komurojun-mbn@nifty.com>
	<20080706103752.13935ffd.komurojun-mbn@nifty.com>
	<4870D46C.7000604@gmail.com>
	<20080707214253.2406f81a.komurojun-mbn@nifty.com>
	<48743A1A.2010304@gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

> Ah... super strange.  Can you please try to swap memory sticks around
> and see whether anything changes to rule out bad memory?  

I tried the pata_pcmcia on 3(three) PC.but the result is same.
So I think the memory is good.

> Another
> possibility is DMA corrupting the memory and printk makes the timing
> different and dodges the bullet.  Does putting msleep(100) in the
> pata_pcmcia init_one make any difference?

I tried the msleep , but it still does not work.

By the way,
If I delete the pata_pcmcia.ko from /lib/modules/...
and insert the ata pcmcia card,
only /sys/bus/pcmcia/devices/0.0 exist.

But if I install the pata_pcmcia.ko,
/sys/bus/pcmcia/devices/0.0 and
/sys/bus/pcmcia/devices/0.1 exist.

Maybe the sysfs or something like that 
is the problem.

Best Regards
Komuro
