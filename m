Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXDXVNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXDXVNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXDXVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:13:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55415 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbXDXVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:13:15 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 24 Apr 2007 17:13:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: William Heimbigner <icxcnika@mar.tar.cc>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk
Subject: Re: [RFC] [PATCH] cpufreq: allow full selection of default governors
In-Reply-To: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
Message-ID: <Pine.LNX.4.64.0704241712160.19442@localhost.localdomain>
References: <Pine.LNX.4.64.0704242057430.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, William Heimbigner wrote:

> The following patches should allow selection of conservative, powersave, and
> ondemand in the kernel configuration.
>
> William Heimbigner
> icxcnika@mar.tar.cc
>
> diff -uprN -X linux-2.6.21-rc7-git6/Documentation/dontdiff
> linux-2.6.21-rc7-git6/drivers/cpufreq/Kconfig
> linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/Kconfig
> --- linux-2.6.21-rc7-git6/drivers/cpufreq/Kconfig	2007-04-25
> 13:03:41.000000000 -0500
> +++ linux-2.6.21-rc7-git6-hwill/drivers/cpufreq/Kconfig	2007-04-25
> 13:08:13.000000000 -0500
> @@ -75,6 +75,24 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
>  	  program shall be able to set the CPU dynamically without having
>  	  to enable the userspace governor manually.
>
> +config CPU_FREQ_DEFAULT_GOV_POWERSAVE
> +	bool "powersave"
> +	select CPU_FREQ_GOV_POWERSAVE
> +	help
> +	  Use the CPUFreq governor 'powersave' as default.
                                                ^^^ the (for consistency)
> +
> +config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
> +	bool "conservative"
> +	select CPU_FREQ_GOV_CONSERVATIVE
> +	help
> +	  Use the CPUFreq governor 'conservative' as the default.
> +
> +config CPU_FREQ_DEFAULT_GOV_ONDEMAND
> +	bool "ondemand"
> +	select CPU_FREQ_GOV_ONDEMAND
> +	help
> +	  Use the CPUFreq governor 'ondemand' as the default.
> +
>  endchoice

rday
