Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXLFTXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXLFTXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLFTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:23:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41810 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXLFTXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:23:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47584C15.7010405@s5r6.in-berlin.de>
Date: Thu, 06 Dec 2007 20:23:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Bernhard Kaindl <bk@suse.de>
CC: Bernhard Kaindl <bkaindl@ffii.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [feedback discussion] Early boot debugging via FireWire (ohci1394_dma=early)
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de> <4755D612.1090103@s5r6.in-berlin.de> <4755D757.7060002@s5r6.in-berlin.de> <alpine.LNX.0.9999-openSUSE-1.0712061732280.21849@jbgna.fhfr.qr>
In-Reply-To: <alpine.LNX.0.9999-openSUSE-1.0712061732280.21849@jbgna.fhfr.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Kaindl wrote:
> linux-2.6.24-rc4/drivers/Makefile:
...
> -obj-$(CONFIG_IEEE1394)        += ieee1394/
> +obj-y                += ieee1394/
...
> The reason for adding it was that drivers/ieee1394/init_ohci1394_dma.c
> does not get compiled if CONFIG_IEEE1394 is not set, but it's not really
> depeding on CONFIG_IEEE1394 being set.

>From what I gather from e.g. drivers/usb/Makefile, you could do it also
this way:

 obj-$(CONFIG_IEEE1394)		+= ieee1394/
+obj-$(CONFIG_PROVIDE_OHCI1394_DMA_INIT) += ieee1394/

-- 
Stefan Richter
-=====-=-=== ==-- --==-
http://arcgraph.de/sr/
