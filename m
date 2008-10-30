Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbYJ3SRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbYJ3SRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYJ3SRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:17:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:58167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755308AbYJ3SRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:17:06 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19hqFYDf4BhwNxahL1ZaWEACQR8b/xRsV+b+1Aixn
	PY7g0Vy/h+9sJI
Date: Thu, 30 Oct 2008 19:17:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Warne <nick@ukfsn.org>
Subject: Re: [PATCH] scsi/tmscsim: fix indentation and braces disagreement
 - add braces
In-Reply-To: <Pine.LNX.4.64.0810301257110.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301913280.8091@axis700.grange>
References: <Pine.LNX.4.64.0810301257110.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008, Ilpo Järvinen wrote:

> 
> Lucky winner is 557cc476c04 ([SCSI] tmscsim: Fixup
> KERN_INFO in printk).
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Cc: Nick Warne <nick@ukfsn.org>

Oops...:-(

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> ---
>  drivers/scsi/tmscsim.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 69ac6e5..9a42734 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2572,9 +2572,10 @@ static struct pci_driver dc390_driver = {
>  
>  static int __init dc390_module_init(void)
>  {
> -	if (!disable_clustering)
> +	if (!disable_clustering) {
>  		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
>  		printk(KERN_INFO "       with \"disable_clustering=1\" and report to maintainers\n");
> +	}
>  
>  	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
>  		tmscsim[0] = 7;
> -- 
> 1.5.2.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
