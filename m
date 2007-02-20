Return-Path: <linux-kernel-owner+w=401wt.eu-S1030231AbXBTQ1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231AbXBTQ1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030230AbXBTQ1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:27:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030221AbXBTQ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:27:36 -0500
Message-ID: <45DB2172.1070003@garzik.org>
Date: Tue, 20 Feb 2007 11:27:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dale Farnsworth <dale@farnsworth.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Eliminate user-selectable CONFIG_MV643XX_ETH_[012]
References: <20070220121520.GA17927@xyzzy.farnsworth.org>
In-Reply-To: <20070220121520.GA17927@xyzzy.farnsworth.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dale Farnsworth wrote:
> From: Dale Farnsworth <dale@farnsworth.org>
> 
> Remove the use of CONFIG_MV643XX_ETH_[012] variables on most
> platforms.  Instead, platform-specific code enables the ports
> supported by the hardware.  After this patch, these config
> variables are only used in arch/ppc, so also move them from
> drivers/net/Kconfig to arch/ppc/Kconfig.
> 
> Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
> 
> ---
> It was a mis-feature that the supported ports were ever user-selectable.
> Which ports the hardware supports should be specified by platform-specific
> code, not by the user.
> 
>  arch/mips/momentum/jaguar_atx/platform.c |   21 ---------------------
>  arch/mips/momentum/ocelot_3/platform.c   |   21 ---------------------
>  arch/mips/momentum/ocelot_c/platform.c   |   14 --------------
>  arch/ppc/Kconfig                         |   15 +++++++++++++++
>  drivers/net/Kconfig                      |   21 ---------------------
>  5 files changed, 15 insertions(+), 77 deletions(-)

ACK.

I'll let Paul, Ralf or Andrew push this one upstream.


