Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZHRT1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZHRT1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 15:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHRT1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 15:27:02 -0400
Received: from www.tglx.de ([62.245.132.106]:53166 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZHRT1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 15:27:00 -0400
Date: Tue, 18 Aug 2009 21:26:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jon Hunter <jon-hunter@ti.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
In-Reply-To: <1250617512-23567-3-git-send-email-jon-hunter@ti.com>
Message-ID: <alpine.LFD.2.00.0908182125590.3361@localhost.localdomain>
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com> <1250617512-23567-2-git-send-email-jon-hunter@ti.com> <1250617512-23567-3-git-send-email-jon-hunter@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Jon Hunter wrote:
> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 3a1dbba..8154bc6 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -77,8 +77,8 @@ enum clock_event_nofitiers {
>  struct clock_event_device {
>  	const char		*name;
>  	unsigned int		features;
> -	unsigned long		max_delta_ns;
> -	unsigned long		min_delta_ns;
> +	unsigned long long	max_delta_ns;
> +	unsigned long long	min_delta_ns;

Can we please use u64 for this ?

Thanks,

	tglx
