Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbXGOKIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbXGOKIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXGOKIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:08:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49565 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbXGOKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:08:09 -0400
Message-ID: <4699F203.2000004@garzik.org>
Date: Sun, 15 Jul 2007 06:08:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
CC: Andrew Morton <akpm@linux-foundation.org>, surya.prabhakar@wipro.com
Subject: Re: [PATCH 5/5] HiSax netjet_s: convert to PCI hotplug API
References: <20070715095716.GA20949@havoc.gtf.org> <20070715100059.GE21220@havoc.gtf.org>
In-Reply-To: <20070715100059.GE21220@havoc.gtf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
> index c7a3794..bf57c43 100644
> --- a/drivers/isdn/hisax/Makefile
> +++ b/drivers/isdn/hisax/Makefile
> @@ -15,6 +15,7 @@ obj-$(CONFIG_HISAX_ST5481)		+= hisax_st5481.o
>  obj-$(CONFIG_HISAX_HFCUSB)		+= hfc_usb.o
>  obj-$(CONFIG_HISAX_HFC4S8S)		+= hfc4s8s_l1.o
>  obj-$(CONFIG_HISAX_FRITZ_PCIPNP)        += hisax_isac.o hisax_fcpcipnp.o
> +obj-$(CONFIG_HISAX_NETJET)		+= nj_s.o # netjet.o isac.o arcofi.o
>  
>  ifdef CONFIG_HISAX_HDLC
>  obj-$(CONFIG_ISDN_DRV_HISAX)		+= isdnhdlc.o
> @@ -47,7 +48,6 @@ hisax-$(CONFIG_HISAX_SEDLBAUER)		+= sedlbauer.o isac.o arcofi.o hscx.o \
>  					   isar.o
>  hisax-$(CONFIG_HISAX_SPORTSTER)		+= sportster.o isac.o arcofi.o hscx.o
>  hisax-$(CONFIG_HISAX_MIC)		+= mic.o isac.o arcofi.o hscx.o
> -hisax-$(CONFIG_HISAX_NETJET)		+= nj_s.o netjet.o isac.o arcofi.o
>  hisax-$(CONFIG_HISAX_NETJET_U)		+= nj_u.o netjet.o icc.o
>  hisax-$(CONFIG_HISAX_HFCS)		+= hfcscard.o hfc_2bds0.o
>  hisax-$(CONFIG_HISAX_HFC_PCI)		+= hfc_pci.o


Careful observers will note this is a bit of a hack.  A minor amount of 
addition work must be put into better defining the dependent modules. 
The above currently works...  but it is sensitive to odd (read: 
non-distro kernel) configurations.

	Jeff


