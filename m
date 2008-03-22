Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYCVSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYCVSSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYCVSSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:18:01 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:57507 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYCVSSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:18:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwDADbq5EfEAmHFZGdsb2JhbACRBRyWcw
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Robert Fitzsimons <robfitz@273k.net>
Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
Date: Sat, 22 Mar 2008 20:17:40 +0200
User-Agent: KMail/1.9.9
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <200803211655.31085.bonganilinux@mweb.co.za> <20080322000557.GA21314@localhost>
In-Reply-To: <20080322000557.GA21314@localhost>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803222017.40862.bonganilinux@mweb.co.za>
X-Original-Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
X-Scan-Signature: ce2b5643cc38920b89336219f3c85980
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2008 02:05:57 Robert Fitzsimons wrote:
> Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
>
> Hi Bongani
>
> I only noticed that you might be using a 32 bit userspace, so the radio
> compat_ioctl needs to be implmented.
>
> Robert
>
>
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c
> b/drivers/media/video/bt8xx/bttv-driver.c index 5404fcc..1bdb726 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3601,6 +3601,7 @@ static const struct file_operations radio_fops =
>  	.read     = radio_read,
>  	.release  = radio_release,
>  	.ioctl	  = video_ioctl2,
> +	.compat_ioctl	= v4l_compat_ioctl32,
>  	.llseek	  = no_llseek,
>  	.poll     = radio_poll,
>  };

I run a 64-bit kernel and 64-bit user-space, only a chrooted version of 
mplayer and it's dependencies are 32 bit, and I don't use them that often.

file /usr/bin/radio
/usr/bin/radio: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for 
GNU/Linux 2.6.9, dynamically linked (uses shared libs), stripped

That patch doesn't help also...


