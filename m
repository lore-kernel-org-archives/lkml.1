Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbXL1Tfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbXL1Tfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXL1TfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:35:13 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:47284 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753432AbXL1TfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:35:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADvedEdMROHU/2dsb2JhbACBV6s8
Date: Fri, 28 Dec 2007 14:30:08 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <adrian.bunk@movial.fi>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       paulus@samba.org, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore Cell OProfile support
Message-ID: <20071228193008.GB23157@Krystal>
References: <20071228185649.GC4738@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071228185649.GC4738@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:29:08 up 55 days, 34 min,  4 users,  load average: 0.12, 0.66,
	0.69
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (adrian.bunk@movial.fi) wrote:
> This patch restores the Cell OProfile support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> 

Same here : why isn't this on by default when SPU_FS and OPROFILE are
enabled ?

> ---
> 
>  kernel/Kconfig.instrumentation |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 6d1446d35d367fdbdd2a0a29e0d156646ff40630 
> diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> index a76635d..9d143e6 100644
> --- a/kernel/Kconfig.instrumentation
> +++ b/kernel/Kconfig.instrumentation
> @@ -53,2 +53,10 @@ config HARDWARE_PM
>  
> +config OPROFILE_CELL
> +	bool "OProfile for Cell Broadband Engine"
> +	depends on PPC && (SPU_FS = y && OPROFILE = m) || (SPU_FS = y && OPROFILE = y) 
> +	default y
> +	help
> +	  Profiling of Cell BE SPUs requires special support enabled
> +	  by this option.
> +
>  config KPROBES
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
