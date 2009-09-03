Return-Path: <linux-kernel-owner+w=401wt.eu-S1754382AbZICR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbZICR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZICR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:27:20 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:50425 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbZICR1T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:27:19 -0400
From: Frans Pop <elendil@planet.nl>
To: Christian =?iso-8859-1?q?Kr=E4mer?= <christian@kraemer-eu.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Thu, 3 Sep 2009 19:27:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl> <200909030042.45081.christian@kraemer-eu.de>
In-Reply-To: <200909030042.45081.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909031927.19590.elendil@planet.nl>
X-OriginalArrivalTime: 03 Sep 2009 17:27:19.0840 (UTC) FILETIME=[CA52A200:01CA2CBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Christian Krämer wrote:
> I also tried to install gentoo offline (with a portage snapshot and
> manually downloaded distfiles). The snapshot was form the 14th August
> 2009. At this time the source packet "gentoo-sources-2.6.30-r4" was the
> current stable for the x86 platform, which I used.

OK. Let's CC the pcmcia experts on this.

Summary: WLAN Card (Proxim Orinoco Gold 8470-WD) is not recognized by 
either 2.6.24 or 2.6.30. After inserting it, 'lspci' does not list the 
card, but 'lspci -H1' does.
Original message with lspci and dmesg output for .24 is at:
http://lkml.org/lkml/2009/9/2/199


Christian: what is the PCI ID of the device? You can find out using
'lspci -H1 -nn'.

Cheers,
FJP
