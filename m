Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZB0BEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZB0BEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZB0BEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:04:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZB0BEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:04:34 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000257.17557.27546.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000257.17557.27546.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 02:04:31 +0100
Message-ID: <154e089b0902261704j8dba825q59411db576a157e8@mail.gmail.com>
Subject: Re: [PATCH 09/16] usb host: fix sparse warning: Using plain integer 
	as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added To]

On Sun, Feb 22, 2009 at 1:04 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warning:
>  drivers/usb/host/oxu210hp-hcd.c:2687:42: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  drivers/usb/host/oxu210hp-hcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
> index 2947c69..5ac489e 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -2684,7 +2684,7 @@ static int oxu_reset(struct usb_hcd *hcd)
>        oxu->urb_len = 0;
>
>        /* FIMXE */
> -       hcd->self.controller->dma_mask = 0UL;
> +       hcd->self.controller->dma_mask = NULL;
>
>        if (oxu->is_otg) {
>                oxu->caps = hcd->regs + OXU_OTG_CAP_OFFSET;
>
>
