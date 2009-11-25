Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbZKYBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbZKYBVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 20:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934156AbZKYBU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 20:20:58 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:50179 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934071AbZKYBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 20:20:57 -0500
Message-ID: <4B0C86BF.10003@snapgear.com>
Date: Wed, 25 Nov 2009 11:22:07 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg Ungerer <gerg@uclinux.org>,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 08/38] move mcf_remove to .devexit.text
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-3-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-4-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-5-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-6-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-7-git-send-email-u.kleine-koenig@pengutronix.de> <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1259096853-18909-8-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Uwe Kleine-König wrote:
> The function mcf_remove is used only wrapped by __devexit_p so define it
> using __devexit.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org

I have this queued in the for-linus (and for-next) branches for
inclusion in 2.6.33 at:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git

Regards
Greg



> ---
>  drivers/serial/mcf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
> index b443824..7bb5fee 100644
> --- a/drivers/serial/mcf.c
> +++ b/drivers/serial/mcf.c
> @@ -602,7 +602,7 @@ static int __devinit mcf_probe(struct platform_device *pdev)
>  
>  /****************************************************************************/
>  
> -static int mcf_remove(struct platform_device *pdev)
> +static int __devexit mcf_remove(struct platform_device *pdev)
>  {
>  	struct uart_port *port;
>  	int i;


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
