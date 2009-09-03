Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZICXv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZICXv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756574AbZICXv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:51:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZICXv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:51:27 -0400
From: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Frans Pop <elendil@planet.nl>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Fri, 4 Sep 2009 01:45:14 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909032007.18484.christian@kraemer-eu.de> <200909032035.10342.elendil@planet.nl>
In-Reply-To: <200909032035.10342.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909040145.14807.christian@kraemer-eu.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/YpBjErjJMJMHpyZYzrk81kBGYhjpS75Hx3xJ
 tvwPEDKrd/7pzECHZWaY66pg4JBq8NA/AAzyEEuLG76WFa7BkT
 zyY2R8tvHi15YGaCxQZvVZ97MnqacPE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 20:35:08 Frans Pop wrote:
> On Thursday 03 September 2009, Christian Krämer wrote:
> > On Thursday 03 September 2009 19:27:18 Frans Pop wrote:
> > > Christian: what is the PCI ID of the device? You can find out using
> > > 'lspci -H1 -nn'.
> >
> > The device class is 0200 and the PCI ID is 168c:0013.
> >
> > Here is the line lspci -H1 -nn shows for the card:
> > 01:00.0 Ethernet controller [0200]: Atheros Communications Inc.
> > AR5212/AR5213 Multiprotocol MAC/baseband processor [168c:0013] (rev 01)
>
> That means that the card should be supported by the ath5k wireless driver
> if it was correctly initialized by the cardbus drivers.


Yes, but on the LiveCD, when I load the module via "modprobe ath5k", ifconfig 
doesn't show any interface except for lo and also dmesg don't display 
anything about a found device. In the gentoo-system I installed, I also tried 
the madwifi-ng driver package, but with the same result.

> I don't think I can help you any further. Hopefully one of the PCMCIA
> developers can. One last suggestion could be to enable the PCMCIA_DEBUG
> option in the kernel and activate that as documented in the Kconfig help
> for that option. Suggest you use a current kernel if you do that.
>
> Good luck,
> FJP

I really thank you, Frans, for managing this problem, for the summary and 
especially for CC'ing it to the pcmcia-mailing list. I admit I'am not very 
familiar with the community around the linux-kernel and this is my first 
request on the official mailing list.

Thank you very much!
Kind regards from myself
