Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXGICsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXGICsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 22:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbXGICsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 22:48:41 -0400
Received: from hqemgate02.nvidia.com ([216.228.112.143]:13931 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781AbXGICsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 22:48:40 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Date: Mon, 9 Jul 2007 10:48:33 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B15F9A3F5@hkemmail01.nvidia.com>
In-Reply-To: <468F41C6.3000109@dunaweb.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
Thread-Index: AcfAaSX3cuwxPcfcRJaNj+pGLb4EBwBZp+Tw
References: <53f198c00707060131x1e1abdd7l4396c7fede360970@mail.gmail.com> <468F41C6.3000109@dunaweb.hu>
From: "Peer Chen" <pchen@nvidia.com>
To: "Zoltan Boszormenyi" <zboszor@dunaweb.hu>, "kuan luo" <kuanluo@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <jeff@garzik.org>,
       <akpm@linux-foundation.org>, <hancockr@shaw.ca>, <prakash@punnoor.de>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 09 Jul 2007 02:48:34.0907 (UTC) FILETIME=[A4B712B0:01C7C1D3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's a rule for all our drivers not just for linux, also if we put the Maxtor drive to the blacklist so that its NCQ function won't be enable for all controllers of other vendors,but we don't have the strong evidence that those Maxtor HDDs are also broken for other controllers.


BRs
Peer Chen

-----Original Message-----
From: Zoltan Boszormenyi [mailto:zboszor@dunaweb.hu] 
Sent: Saturday, July 07, 2007 3:33 PM
To: kuan luo
Cc: linux-kernel@vger.kernel.org; jeff@garzik.org; akpm@linux-foundation.org; hancockr@shaw.ca; prakash@punnoor.de; Peer Chen; Kuan Luo
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61

kuan luo írta:
> From: Kuan Luo <kluo@nvidia.com>
>
> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA 
> controller.  NCQ function is disable by default, you can enable it 
> with 'swncq=1'. NCQ will be turned off if the drive is Maxtor on MCP51 
> or
> MCP55 rev 0xa2  platform.
>
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> ---

Thanks, I am using it on 2.6.22-rc7-git5, have run a stress test yesterday night.
It seems to be as stable as the previous version. I guess it's safe to turn it on by default when it gets into Linus' kernels.

I have a question though. Why is the blanket needed for Maxtor drives?
Can't it be narrowed down to certain models? Maybe those models should be put into libata blacklist...
Not that my current machine is affected, I am just curious.

Best regards,
Zoltán Böszörményi


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
