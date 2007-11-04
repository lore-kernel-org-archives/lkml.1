Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbXKDB3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbXKDB3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 21:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbXKDB3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 21:29:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47021 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756134AbXKDB3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 21:29:22 -0400
Date: Sun, 4 Nov 2007 02:28:59 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] x86: unification of cfufreq/Kconfig
Message-ID: <20071104012858.GH12045@stusta.de>
References: <11941338801315-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11941338801315-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2007 at 12:51:11AM +0100, Sam Ravnborg wrote:
>...
>  config X86_SPEEDSTEP_CENTRINO
> -	tristate "Intel Enhanced SpeedStep"
> +	tristate "Intel Enhanced SpeedStep (deprecated)"
>  	select CPU_FREQ_TABLE
> -	select X86_SPEEDSTEP_CENTRINO_TABLE
> +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
>  	help
>...

	depends on ACPI_PROCESSOR if X86_64



cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

