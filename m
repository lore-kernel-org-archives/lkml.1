Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZG0MzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZG0MzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZG0MzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:55:04 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43252
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754001AbZG0MzC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:55:02 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1803O1432R98dNzz1202hzz5a6ciz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNFYJD-03-TW2-01
Date: Mon, 27 Jul 2009 14:54:50 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: wan wei <onewayforever@gmail.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: to read the right f2maskoffset reg
Message-ID: <20090727125450.GD28229@aftab>
References: <86bb1aef0907241215v3d693c6n40721684d16c4740@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <86bb1aef0907241215v3d693c6n40721684d16c4740@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2009 12:54:48.0149 (UTC) FILETIME=[6C421850:01CA0EB9]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 25, 2009 at 03:15:05AM +0800, wan wei wrote:
> Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn, onewayforever@gmail.com>

Nice catch, thanks. Applied.

P.S. Please use only one email address in your Signed-off-by. I'm going
to default to your sender email address.

> ---
>  drivers/edac/amd64_edac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 858fe60..24964c1 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -970,7 +970,7 @@ static void amd64_read_dct_base_mask(struct amd64_pvt *pvt)
>         }
> 
>         for (cs = 0; cs < pvt->num_dcsm; cs++) {
> -               reg = K8_DCSB0 + (cs * 4);
> +               reg = K8_DCSM0 + (cs * 4);
>                 err = pci_read_config_dword(pvt->dram_f2_ctl, reg,
>                                         &pvt->dcsm0[cs]);
>                 if (unlikely(err))
> -- 
> 1.4.4.2
> 

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

