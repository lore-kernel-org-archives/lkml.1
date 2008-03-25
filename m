Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYCYRQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYCYRQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYCYRQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:16:08 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:46035 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYCYRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:16:07 -0400
Message-ID: <47E93350.6090806@freescale.com>
Date: Tue, 25 Mar 2008 12:16:00 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] CPM1: implement GPIO LIB API
References: <47E92EC8.7010700@scram.de>
In-Reply-To: <47E92EC8.7010700@scram.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> diff --git a/arch/powerpc/platforms/8xx/Kconfig b/arch/powerpc/platforms/8xx/Kconfig
> index 7fd224c..e12cbf0 100644
> --- a/arch/powerpc/platforms/8xx/Kconfig
> +++ b/arch/powerpc/platforms/8xx/Kconfig
> @@ -4,6 +4,8 @@ config FADS
>  config CPM1
>  	bool
>  	select CPM
> +	select GENERIC_GPIO
> +	select GPIO_LIB

Shouldn't this depend on the user enabling GPIO support?  Some 8xx 
boards are very memory-constrained, so we don't want to be making the 
kernel even bigger than it already is unless it's actually needed.

-Scott
