Return-Path: <linux-kernel-owner+w=401wt.eu-S1765001AbZDIJuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765001AbZDIJuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764351AbZDIJt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:49:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33997 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759579AbZDIJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:49:56 -0400
X-Sasl-enc: DvO+gQiV9kzTMbiooMACzhKJgUGe0XtSuiPV0Uu+g50V 1239270594
Message-ID: <49DDC4C0.5080103@fastmail.fm>
Date: Thu, 09 Apr 2009 10:49:52 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Jesper Nilsson <jesper.nilsson@axis.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeff@garzik.org" <jeff@garzik.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       starvik@axis.com, Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH 08/56] cris: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <20090408123537.GI8115@axis.com> <49DCA863.3000800@fastmail.fm>
In-Reply-To: <49DCA863.3000800@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I CCd the wrong patch. Here is the corrected version

Thanks,

Jack

Jack Stone wrote:
> Hi Jesper,
>
> That patch might be wrong. Here's a revised version:
>
> Thanks
>
> Jack
>
> cris: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  arch/cris/arch-v32/drivers/cryptocop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/cris/arch-v32/drivers/cryptocop.c
> b/arch/cris/arch-v32/drivers/cryptocop.c
> index 67c61ea..f2ffabb 100644
> --- a/arch/cris/arch-v32/drivers/cryptocop.c
> +++ b/arch/cris/arch-v32/drivers/cryptocop.c
> @@ -2784,7 +2784,7 @@ static int cryptocop_ioctl_process(struct inode
> *inode, struct file *filp, unsig
>          tmplen -= cop->tfrm_op.indata[0].iov_len;
>          for (i = 1; i<noinpages; i++){
>              cop->tfrm_op.indata[i].iov_len = tmplen < PAGE_SIZE ?
> tmplen : PAGE_SIZE;
> -            cop->tfrm_op.indata[i].iov_base = (unsigned
> char*)page_address(inpages[i]);
> +            cop->tfrm_op.indata[i].iov_base = page_address(inpages[i]);
>              tmplen -= PAGE_SIZE;
>          }
>      } else {
>
>   

