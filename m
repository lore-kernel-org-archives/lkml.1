Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZAIHfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZAIHfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZAIHez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:34:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:46475 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZAIHey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:34:54 -0500
Subject: Re: Bug#506964: [PATCH] suspend/resume for ATI Mobility Radeon
 RV350
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Wolfgang Kroener <lkml@azog.de>, 506964@bugs.debian.org
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20090108205731.GE15240@lupus.ipv6.sieglitzhof.net>
References: <20080930140658.GL10156@casella.faui2k3.org>
	 <1222812610.9006.74.camel@pasglop>
	 <20090108205731.GE15240@lupus.ipv6.sieglitzhof.net>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 18:34:30 +1100
Message-Id: <1231486470.2142.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 21:57 +0100, Wolfgang Kroener wrote:
> Hi,
> On Wed, Oct 01, 2008 at 08:10:10, Benjamin Herrenschmidt wrote:
> > Can you resend it with a proper Signed-off-by: line ? Thanks !
> 
> I think the mail (http://lkml.org/lkml/2008/10/1/134) got lost
> somewhere, so I try again:

Fell through the cracks along with some of my own radeonfb patches :-)

Thanks for reminding.

Cheers,
Ben.

> 
> radeonfb suspend/resume for Acer Travelmate 29X
> 
> This patch adds suspend/resume for the Acer Travelmate 290D/292LMi with
> the following graphic-chip:
> 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350
> [Mobility Radeon 9600 M10] [1002:4e50] (prog-if 00 [VGA controller])
> 	Subsystem: Acer Incorporated [ALI] TravelMate 290 [1025:005a]
> 	Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 10
> 	Memory at a8000000 (32-bit, prefetchable) [size=128M]
> 	I/O ports at c100 [size=256]
> 	Memory at e0010000 (32-bit, non-prefetchable) [size=64K]
> 	[virtual] Expansion ROM at a0000000 [disabled] [size=128K]
> 	Capabilities: [58] AGP version 2.0
> 	Capabilities: [50] Power Management version 2
> 	Kernel driver in use: radeonfb
> 	Kernel modules: radeonfb
> 
> Signed-off-by: Wolfgang Kroener <lkml@azog.de>
> ---
>  drivers/video/aty/radeon_pm.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
> index 675abda..5e4b2da 100644
> --- a/drivers/video/aty/radeon_pm.c
> +++ b/drivers/video/aty/radeon_pm.c
> @@ -89,6 +89,9 @@ static struct radeon_device_id radeon_workaround_list[] = {
>  	BUGFIX("Acer Aspire 2010",
>  	       PCI_VENDOR_ID_AI, 0x0061,
>  	       radeon_pm_off, radeon_reinitialize_M10),
> +	BUGFIX("Acer Travelmate 290D/292LMi",
> +	       PCI_VENDOR_ID_AI, 0x005a,
> +	       radeon_pm_off, radeon_reinitialize_M10),
>  	{ .ident = NULL }
>  };
>  
> -- 
> 1.5.6.5
> 
> 
> 

