Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZHGPc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZHGPc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZHGPcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:32:55 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:42171 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZHGPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZmzvOZnInArBp9hRLlxDIMaL2dtRgcSBzh40kszaKDPDZqQIFS7CLi2n7HIX1TAzAs
         YBFVKNzj4WDofRSZqWxRPSu3b42Ff5Lhtl0Fz85VeKNIE9SbepfQepOej5IhQNkQGTkS
         2RA4xXAgsx9u++HxqPMRj/A8OcmcG2HGkZL/I=
MIME-Version: 1.0
In-Reply-To: <20090804221506.GA9256@cuplxvomd02.corp.sa.net>
References: <20090804221506.GA9256@cuplxvomd02.corp.sa.net>
Date: Fri, 7 Aug 2009 16:32:52 +0100
Message-ID: <9b2b86520908070832p2d1658b0t8b1d89d1a034bb9a@mail.gmail.com>
Subject: Re: [PATCH 2/7 v3] initdev:kernel:USB init device discovery 
	notification
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/09, David VomLehn <dvomlehn@cisco.com> wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
>
> Use init device discovery infrastructure to provide notification of
> availability of USB devices.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: David VomLehn <dvomlehn@cisco.com>
> ---
>  drivers/usb/core/hub.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index be86ae3..08baee0 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -37,6 +37,20 @@
>  #endif
>  #endif
>
> +/* The mask of possible USB boot devices depends on what drivers and
> + * options have been configured into the kernel.  There are too many
> + * USB network config options to list here, so just assume it is always
> + * possible to have a USB network device.
> + */

That could be fixed though.  Make the "USB Network Adaptors" menu into
an option.  Then you just have e.g. "CONFIG_NETDEV_USB", plus the two
class devices outside the menu (CONFIG_USB_ACM and CONFIG_USB_WDM).

Alan
