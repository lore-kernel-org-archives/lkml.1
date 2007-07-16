Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbXGPTqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbXGPTqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXGPTp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:45:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51464 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbXGPTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:45:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <469BCAB2.5060909@s5r6.in-berlin.de>
Date: Mon, 16 Jul 2007 21:44:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@brturbo.com.br>,
       Dominik Brodowski <linux@brodo.de>, Christoph Hellwig <hch@lst.de>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>
Subject: Re: how about bringing Documentation/feature-removal-schedule.txt
 up to date?
References: <Pine.LNX.4.64.0707160759080.17044@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707160759080.17044@localhost.localdomain>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   as time goes by, the informational value of the feature removal file
> is rapidly approaching zero, as alleged deadlines for removal are
> continually dismissed, while some removal dates as far back as 2005
> are still in that file.
> 
>   if those features aren't going to be removed, then will someone at
> least recalibrate their removal dates and update that file?

I'm adding Ccs of a few people, as LKML is a high volume list.
Overdue items are:

What:	Video4Linux API 1 ioctls and video_decoder.h from Video devices.
When:	December 2006

What:	PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:	November 2005

What:	remove EXPORT_SYMBOL(kernel_thread)
When:	August 2006

What:	CONFIG_FORCED_INLINING
When:	June 2006

What:   eepro100 network driver
When:   January 2007

What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
	(temporary transition config option provided until then)
When:	before 2.6.19

What:	i2c-isa
When:	December 2006

What:  drivers depending on OBSOLETE_OSS   [sic]
When:  options in 2.6.22, code in 2.6.24

	Note 1:	This entry is superseded by
		What:  drivers depending on OSS_OBSOLETE
		When:  options in 2.6.23, code in 2.6.25

	Note 2:	Current linux-2.6.22-git* has SOUND_BT878 and
		SOUND_CS4232 depending on OSS_OBSOLETE.

What:	/sys/firmware/acpi/namespace
When:	2.6.21
-- 
Stefan Richter
-=====-=-=== -=== =----
http://arcgraph.de/sr/
