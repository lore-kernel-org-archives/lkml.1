Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZJBAyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZJBAyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZJBAyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:54:03 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:55207 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540AbZJBAyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:54:02 -0400
Message-ID: <4AC54F0F.7040202@snapgear.com>
Date: Fri, 02 Oct 2009 10:53:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 11/34] move mcf_remove to .devexit.text
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-11-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-11-git-send-email-u.kleine-koenig@pengutronix.de>
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

Looks good. I'll add that to the m68knommu git, for-linus branch.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
