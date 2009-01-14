Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZANFfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZANFfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZANFfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:35:08 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:21610 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbZANFfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eJeGFTGJ26PY5jn26Bc6TeLyaugKl2XUdMDW1LGlHAbz7kgnzP4j2qEhRZnHsuFukg
         cfHjVCfP9kbD1amM420TyYlyza/FiQlf9zg641v8NGQ2JHiFm34i7n76S15oqdWDkhxa
         LoH866VP5PLLVsB6Mg4cHyMfVnhKFxel/hMqY=
Date: Tue, 13 Jan 2009 21:34:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move omap-keypad's probe function to .devinit.text
Message-ID: <20090114053423.GA4375@dtor-d630.eng.vmware.com>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-35-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231799107-20136-35-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:24:40PM +0100, Uwe Kleine-König wrote:
> A pointer to omap_kp_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 

Applied, thank you Uwe.

-- 
Dmitry
