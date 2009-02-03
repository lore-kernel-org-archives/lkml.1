Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZBCAe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZBCAe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZBCAes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:34:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:35810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZBCAes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wb+uRBVoqUdbYcI9C7ALq8oQc2F02BY7W/lJhRl6cR8jwQiXvOX1oKMm1oA7Rlb7S/
         GYHO+6QJfZ4wYgCllYQh+d5FjkJOYB7GyxiULCfGCRtQmMptdkuI3b/HKhyR6KIv1803
         g4BDAmU1A+fHluVGWkaJBHrmu7a4wOkjrRYuA=
Date: Tue, 3 Feb 2009 03:34:42 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 2/3] pcf50633_charger: Remove mbc_set_status
Message-ID: <20090203003442.GC29462@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20090127135238.6875.26314.stgit@fedora.yogi> <20090127135255.6875.64874.stgit@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090127135255.6875.64874.stgit@fedora.yogi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 07:22:55PM +0530, Balaji Rao wrote:
> Remove unused 'pcf50633_mbc_set_status' function.
> 
> Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> Cc: Andy Green <andy@openmoko.com>
> Cc: Anton Vorontsov <cbou@mail.ru>
> ---

This patch applied to battery-2.6.git (i.e. for 2.6.30).

Thanks!

>  drivers/power/pcf50633-charger.c |   15 ---------------
>  include/linux/mfd/pcf50633/mbc.h |    1 -
>  2 files changed, 0 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
> index 41aec2a..aceffdc 100644
> --- a/drivers/power/pcf50633-charger.c
> +++ b/drivers/power/pcf50633-charger.c
> @@ -84,21 +84,6 @@ int pcf50633_mbc_get_status(struct pcf50633 *pcf)
>  }
>  EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
>  
> -void pcf50633_mbc_set_status(struct pcf50633 *pcf, int what, int status)
> -{
> -	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
> -
> -	if (what & PCF50633_MBC_USB_ONLINE)
> -		mbc->usb_online = !!status;
> -	if (what & PCF50633_MBC_USB_ACTIVE)
> -		mbc->usb_active = !!status;
> -	if (what & PCF50633_MBC_ADAPTER_ONLINE)
> -		mbc->adapter_online = !!status;
> -	if (what & PCF50633_MBC_ADAPTER_ACTIVE)
> -		mbc->adapter_active = !!status;
> -}
> -EXPORT_SYMBOL_GPL(pcf50633_mbc_set_status);
> -
>  static ssize_t
>  show_chgmode(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> diff --git a/include/linux/mfd/pcf50633/mbc.h b/include/linux/mfd/pcf50633/mbc.h
> index 6e17619..4119579 100644
> --- a/include/linux/mfd/pcf50633/mbc.h
> +++ b/include/linux/mfd/pcf50633/mbc.h
> @@ -128,7 +128,6 @@ enum pcf50633_reg_mbcs3 {
>  int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma);
>  
>  int pcf50633_mbc_get_status(struct pcf50633 *);
> -void pcf50633_mbc_set_status(struct pcf50633 *, int what, int status);
>  
>  #endif

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
