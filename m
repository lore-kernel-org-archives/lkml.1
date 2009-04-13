Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZDMITF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZDMITF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZDMISw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:18:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51480 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbZDMISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:18:52 -0400
Message-ID: <49E2F55F.5060108@garzik.org>
Date: Mon, 13 Apr 2009 04:18:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sata_nv: sgpio for nvidia mcp55 -v3
References: <20061031104055.GA8898@infradead.org>	 <15F501D1A78BD343BE8F4D8DB854566B0C8DDCF5@hkemmail01.nvidia.com>	 <86802c440711062009t7e98d27fqdfb466b9843da060@mail.gmail.com> <86802c440901180120u3e60e73dm53a37b7cd9034915@mail.gmail.com> <4972F4E5.3030203@kernel.org> <49768355.4040301@kernel.org> <4977DAAF.5060006@kernel.org>
In-Reply-To: <4977DAAF.5060006@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Impact: new features
> 
> based on patch on
>     http://marc.info/?l=linux-ide&m=116289338705418&w=2
> 
> 1. update the patch for 2.6.19 to latest upstream ( 2.6.28?)
> 2. fix shared sgpio to support several mcp55 + io55, so every mcp55 have
>    seperate spinlock
> 3. use scratch_source as numbering of sgpio instead of address of struct,
>    so could go through kexec/kdump
> 
> v2: revert NV_ON and NV_OFF, so turn on Activity LED all the time when disk is idle.
> v3: use one timer per sgpio instead of per nv_host, so for mcp55+io55 system will use 2 timers
>     instead of 6 timers.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/ata/sata_nv.c |  562 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 562 insertions(+)


Is this really over 500 LOC, just to blink some lights from the data 
xfer hot path?  :)

	Jeff



