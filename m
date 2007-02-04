Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXBDBP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXBDBP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXBDBP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:15:56 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36316 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXBDBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:15:55 -0500
Date: Sat, 3 Feb 2007 17:06:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@osdl.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       Pravin <shindepravin@gmail.com>, uml@flonatel.org
Subject: Re: [patch 25/59] Fix UML on non-standard VM split hosts
Message-Id: <20070203170654.fd0e1d7d.randy.dunlap@oracle.com>
In-Reply-To: <20070203024138.485584000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
	<20070203024138.485584000@sous-sol.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 18:35:29 -0800 Chris Wright wrote:

> -stable review patch.  If anyone has any objections, please let us know.
> ------------------
> 
> From: Jeff Dike <jdike@addtoit.com>
> 
> This fixes UML on hosts with non-standard VM splits.  We had changed
> the config variable that controls UML behavior on such hosts, but not
> propogated the change everywhere.  In particular, the values of
> STUB_CODE and STUB_DATA relied on the old variable.
> 
> I also reformatted the HOST_VMSPLIT_3G help to make it more standard.

The reformatting looks bad to me.  Kconfig help text should be
indented consistently by 2 spaces under "help".

This can be fixed later if you don't want to drop it from -stable.


> Spotted by uml@flonatel.org.
> 
> Signed-off-by: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> --
>  arch/um/Kconfig.i386 |   38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> --- linux-2.6.19.2.orig/arch/um/Kconfig.i386
> +++ linux-2.6.19.2/arch/um/Kconfig.i386
> @@ -19,22 +19,22 @@ config SEMAPHORE_SLEEPERS
>  choice
>  	prompt "Host memory split"
>  	default HOST_VMSPLIT_3G
> -	---help---
> -	   This is needed when the host kernel on which you run has a non-default
> -	   (like 2G/2G) memory split, instead of the customary 3G/1G. If you did
> -	   not recompile your own kernel but use the default distro's one, you can
> -	   safely accept the "Default split" option.
> -
> -	   It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
> -	   CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
> -	   patchset by Con Kolivas, or other ones) - option names match closely the
> -	   host CONFIG_VM_SPLIT_* ones.
> -
> -	   A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
> -	   tolerate even more "normal" host kernels, but an higher setting will be
> -	   stricter.
> +	help
> +        This is needed when the host kernel on which you run has a non-default
> +	(like 2G/2G) memory split, instead of the customary 3G/1G. If you did
> +	not recompile your own kernel but use the default distro's one, you can
> +	safely accept the "Default split" option.
> +
> +	It can be enabled on recent (>=2.6.16-rc2) vanilla kernels via
> +	CONFIG_VM_SPLIT_*, or on previous kernels with special patches (-ck
> +	patchset by Con Kolivas, or other ones) - option names match closely the
> +	host CONFIG_VM_SPLIT_* ones.
> +
> +	A lower setting (where 1G/3G is lowest and 3G/1G is higher) will
> +	tolerate even more "normal" host kernels, but an higher setting will be
> +	stricter.
>  
> -	   So, if you do not know what to do here, say 'Default split'.
> +	So, if you do not know what to do here, say 'Default split'.
>  
>  	config HOST_VMSPLIT_3G
>  		bool "Default split (3G/1G user/kernel host split)"


---
~Randy
