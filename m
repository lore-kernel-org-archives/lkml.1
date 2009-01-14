Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbZANFfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbZANFfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZANFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:35:28 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:21610 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbZANFf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:35:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XVkpUvvNB1CrxWbT2UgP3Q+ImZ3hRQfsCGx9jjR/ugr0gi74/x5DIVD0Lt71qc8MqW
         LF0UoIFo495JCkvAaLeU7gSaeiUXZb1HV+c5hyxlJ/2JXSZlOH/4pLLLfOPUToVsMeg1
         I1HSmdIRbjLtUUm7+h/jglbPRbzxXbxTEavoo=
Date: Tue, 13 Jan 2009 21:34:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move spitz-keyboard's probe function to .devinit.text
Message-ID: <20090114053446.GB4375@dtor-d630.eng.vmware.com>
References: <S1757830AbZALWQu/20090112221650Z+1710@vger.kernel.org> <1231799107-20136-53-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231799107-20136-53-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:24:58PM +0100, Uwe Kleine-König wrote:
> A pointer to spitzkbd_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
> 

Applied as well, thank you.

-- 
Dmitry
