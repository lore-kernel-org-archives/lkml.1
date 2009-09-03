Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbZICSfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbZICSfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbZICSfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:35:10 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:50589 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbZICSfJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:35:09 -0400
From: Frans Pop <elendil@planet.nl>
To: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Thu, 3 Sep 2009 20:35:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <200909032007.18484.christian@kraemer-eu.de>
In-Reply-To: <200909032007.18484.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909032035.10342.elendil@planet.nl>
X-OriginalArrivalTime: 03 Sep 2009 18:35:10.0750 (UTC) FILETIME=[44C633E0:01CA2CC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Christian Krämer wrote:
> On Thursday 03 September 2009 19:27:18 Frans Pop wrote:
> > Christian: what is the PCI ID of the device? You can find out using
> > 'lspci -H1 -nn'.
>
> The device class is 0200 and the PCI ID is 168c:0013.
>
> Here is the line lspci -H1 -nn shows for the card:
> 01:00.0 Ethernet controller [0200]: Atheros Communications Inc.
> AR5212/AR5213 Multiprotocol MAC/baseband processor [168c:0013] (rev 01)

That means that the card should be supported by the ath5k wireless driver 
if it was correctly initialized by the cardbus drivers.

I happen to have a similar PCMCIA card (from a different vendor: Trust) 
that has the same PCI ID and works without problems.

I don't think I can help you any further. Hopefully one of the PCMCIA 
developers can. One last suggestion could be to enable the PCMCIA_DEBUG 
option in the kernel and activate that as documented in the Kconfig help 
for that option. Suggest you use a current kernel if you do that.

Good luck,
FJP
