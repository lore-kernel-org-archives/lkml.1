Return-Path: <linux-kernel-owner+w=401wt.eu-S936005AbZDIQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936005AbZDIQow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935973AbZDIQf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:35:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:28180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935971AbZDIQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jmghOazuojiWXL44z8tQJsOamlU2UKkDyFCOreMiGykWgod4pfIHkBLyB2t4lnNmjc
         Hy0OaNyExme7d3mvujK9CPPe/x21olyqmNH6iVi/eMmZwnNO14wFwbFJym7Z4U5XZ5J2
         n1kFVSazN3oI+EMUlt5XAMSbNXOlsHKbrymcY=
Date: Thu, 9 Apr 2009 09:35:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: hp_sdc_rtc should depend on serio
Message-ID: <20090409163514.GB15250@dtor-d630.eng.vmware.com>
References: <20090403111621.GA29023@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403111621.GA29023@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Fri, Apr 03, 2009 at 03:16:21PM +0400, Alexander Beregalov wrote:
> Fix this build error when CONFIG_SERIO is not set
> hp_sdc_rtc.c:691: undefined reference to `hp_sdc_request_timer_irq'
> and so on..
> 
> "select should be used with care. select will force
> a symbol to a value without visiting the dependencies."
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  drivers/input/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 203abac..ae5d7dc 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -215,6 +215,7 @@ config INPUT_SGI_BTNS
>  config HP_SDC_RTC
>  	tristate "HP SDC Real Time Clock"
>  	depends on GSC || HP300
> +	select SERIO

Why don'we make it "depend on SERIO"?

-- 
Dmitry
