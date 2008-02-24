Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbYBXLQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbYBXLQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 06:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYBXLPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 06:15:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYBXLPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 06:15:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] u132-hcd: add missing braces
Date: Sun, 24 Feb 2008 12:14:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, tony.olech@elandigitalsystems.com,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20080224153404.bed65e80.sfr@canb.auug.org.au>
In-Reply-To: <20080224153404.bed65e80.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241214.46817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 24 of February 2008, Stephen Rothwell wrote:
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks, this has been fixed already in the mainline.

> ---
>  drivers/usb/host/u132-hcd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Discovered while building Linus' tree for today's linux-next. Not the
> correct patch, but allowed compilation to succeed.
> 
> diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
> index 6fca069..648ad1a 100644
> --- a/drivers/usb/host/u132-hcd.c
> +++ b/drivers/usb/host/u132-hcd.c
> @@ -3221,11 +3221,13 @@ static int u132_suspend(struct platform_device *pdev, pm_message_t state)
>  			break;
>  		case PM_EVENT_SUSPEND:
>  		case PM_EVENT_HIBERNATE:
> +			{
>                          int ports = MAX_U132_PORTS;
>                          while (ports-- > 0) {
>                                  port_power(u132, ports, 0);
>                          }
>  			break;
> +			}
>  		}
>                  if (retval == 0)
>                          pdev->dev.power.power_state = state;
> -- 
> 1.5.4.2
