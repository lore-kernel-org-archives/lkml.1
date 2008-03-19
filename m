Return-Path: <linux-kernel-owner+w=401wt.eu-S937940AbYCSVkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937940AbYCSVkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbYCSUKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:10:01 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53700 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764230AbYCSUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:09:55 -0400
Date: Wed, 19 Mar 2008 13:06:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/13] x86: PAT infrastructure patch
Message-Id: <20080319130639.819777b7.randy.dunlap@oracle.com>
In-Reply-To: <20080319000058.541493000@intel.com>
References: <20080319000012.439150000@intel.com>
	<20080319000058.541493000@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 17:00:14 -0700 venkatesh.pallipadi@intel.com wrote:

diffstat would be very nice to have.


> Index: linux-2.6-x86.git/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6-x86.git.orig/arch/x86/Kconfig	2008-03-17 11:06:47.000000000 -0700
> +++ linux-2.6-x86.git/arch/x86/Kconfig	2008-03-17 11:06:51.000000000 -0700
> @@ -1013,6 +1013,21 @@
>  
>  	  See <file:Documentation/mtrr.txt> for more information.
>  
> +config X86_PAT
> +	def_bool y
> +	prompt "x86 PAT support"
> +	depends on MTRR && NONPROMISC_DEVMEM
> +	help
> +	  Use PAT attributes to setup page level cache control.
> +	---help---
> +	  PATs are the modern equivalents of MTRRs and are much more
> +	  flexible than MTRRs.
> +

Do 2 help sections actually work?  We don't usually do that.
Just change the second one to a blank line.

> +	  Say N here if you see bootup problems (boot crash, boot hang,
> +	  spontaneous reboots) or a non-working Xorg.

Maybe "a non-working Xorg video driver" ?
or even omit Xorg and just say video driver?

> +
> +	  If unsure, say Y.
> +
>  config EFI
>  	def_bool n
>  	prompt "EFI runtime service support"


---
~Randy
