Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYGIVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYGIVqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYGIVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:46:30 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36798 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYGIVqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:46:30 -0400
Message-ID: <4875320D.2070306@keyaccess.nl>
Date: Wed, 09 Jul 2008 23:47:57 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
References: <20080709202719.GB22744@sgi.com> <4875266B.4020504@keyaccess.nl> <20080709213622.GC22744@sgi.com>
In-Reply-To: <20080709213622.GC22744@sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-07-08 23:36, Russ Anderson wrote:

>> ... and wouldn't uv_bios_strerror/uv_bios_freq_base be better names?
> 
> The plan is for both x86 and ia64 versions of uv, with this being
> the x86 version.  The ia64 version has ia64_sal_strerror()
> and ia64_sal_freq_base().  Hence the x86_bios_* naming convention.
> I'm not strongly tied to that convention, it just seemed logical.

Ah, I see. Not much of an opinion then. x86_bios sounds a bit generic, 
but whatever...

> Here is the updated patch.

[ ... ]

> +enum {
> +	BIOS_STATUS_SUCCESS		=  0,
> +	BIOS_STATUS_UNIMPLEMENTED	= -1,
> +	BIOS_STATUS_EINVAL		= -2,
> +	BIOS_STATUS_ERROR		= -3
> +};

[ .. ]

> +extern long
> +x86_bios_freq_base(unsigned long which, unsigned long *ticks_per_second,
> +		   unsigned long *drift_info);

> +static __init void uv_rtc_init(void)
> +{
> +	unsigned long status, ticks_per_sec, drift;

*status* should remain a long :-)

Rene.
