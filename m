Return-Path: <linux-kernel-owner+w=401wt.eu-S2992866AbXCCBRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992866AbXCCBRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992858AbXCCBRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:17:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55552 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992865AbXCCBRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:17:34 -0500
Message-ID: <45E8CCAC.7040304@garzik.org>
Date: Fri, 02 Mar 2007 20:17:32 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dale Farnsworth <dale@farnsworth.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 2/2] mv643xx_eth: Place explicit port number in mv643xx_eth_platform_data
References: <20070301233148.GA19550@xyzzy.farnsworth.org> <20070301233324.GA20193@xyzzy.farnsworth.org>
In-Reply-To: <20070301233324.GA20193@xyzzy.farnsworth.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Farnsworth wrote:
> We were using the platform_device.id field to identify which ethernet
> port is used for mv643xx_eth device.  This is not generally correct.
> It will be incorrect, for example, if a hardware platform uses a single
> port but not the first port.  Here, we add an explicit port_number field
> to struct mv643xx_eth_platform_data.
> 
> This makes the mv643xx_eth_platform_data structure required, but that
> isn't an issue since all users currently provide it already.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> 
> ---
> 
>  arch/mips/momentum/jaguar_atx/platform.c  |    8 ++
>  arch/mips/momentum/ocelot_3/platform.c    |    8 ++
>  arch/mips/momentum/ocelot_c/platform.c    |    4 +
>  arch/powerpc/platforms/chrp/pegasos_eth.c |    2 
>  arch/ppc/syslib/mv64x60.c                 |   12 +++-
>  drivers/net/mv643xx_eth.c                 |   59 ++++++++++----------
>  include/linux/mv643xx.h                   |    1 
>  7 files changed, 62 insertions(+), 32 deletions(-)

ACK but not applied, patch corrupted


