Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXGGHdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXGGHdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 03:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXGGHdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 03:33:43 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:53695 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXGGHdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 03:33:42 -0400
Message-ID: <468F41C6.3000109@dunaweb.hu>
Date: Sat, 07 Jul 2007 09:33:26 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: kuan luo <kuanluo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, akpm@linux-foundation.org,
       hancockr@shaw.ca, prakash@punnoor.de, pchen@nvidia.com, kluo@nvidia.com
Subject: Re: [PATCH] ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
References: <53f198c00707060131x1e1abdd7l4396c7fede360970@mail.gmail.com>
In-Reply-To: <53f198c00707060131x1e1abdd7l4396c7fede360970@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kuan luo írta:
> From: Kuan Luo <kluo@nvidia.com>
>
> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
> controller.  NCQ function is disable by default, you can enable it with
> 'swncq=1'. NCQ will be turned off if the drive is Maxtor on MCP51 or
> MCP55 rev 0xa2  platform.
>
> Signed-off-by: Kuan Luo <kluo@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>
> ---

Thanks, I am using it on 2.6.22-rc7-git5, have run a stress test 
yesterday night.
It seems to be as stable as the previous version. I guess it's safe to 
turn it on
by default when it gets into Linus' kernels.

I have a question though. Why is the blanket needed for Maxtor drives?
Can't it be narrowed down to certain models? Maybe those models
should be put into libata blacklist...
Not that my current machine is affected, I am just curious.

Best regards,
Zoltán Böszörményi


