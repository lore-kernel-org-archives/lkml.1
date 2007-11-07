Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXKGGCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXKGGCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXKGGCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:02:45 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39612 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750695AbXKGGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:02:44 -0500
Date: Wed, 7 Nov 2007 07:02:20 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unification of cfufreq/Kconfig
Message-ID: <20071107060220.GX26163@stusta.de>
References: <11943900793940-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11943900793940-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:01:12AM +0100, Sam Ravnborg wrote:
>...
>  config X86_SPEEDSTEP_CENTRINO
> -	tristate "Intel Enhanced SpeedStep"
> +	tristate "Intel Enhanced SpeedStep (deprecated)"
>  	select CPU_FREQ_TABLE
> -	select X86_SPEEDSTEP_CENTRINO_TABLE
> +	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
> +	depends on X86_64 && ACPI_PROCESSOR
>...

No.

	depends on ACPI_PROCESSOR if X86_64



cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

