Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZABIC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZABIC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZABICq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:02:46 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37729 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZABICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:02:46 -0500
Date: Fri, 2 Jan 2009 09:04:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bastian Blank <bastian@waldi.eu.org>,
       "David S. Miller" <davem@davemloft.net>, linux-sparc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: Use 64BIT config entry
Message-ID: <20090102080420.GA2107@uranus.ravnborg.org>
References: <20090101193504.GA4368@wavehammer.waldi.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090101193504.GA4368@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 08:35:04PM +0100, Bastian Blank wrote:
> Use 64BIT config entry to distinguish between 32 and 64bit builds
> instead of relying on the ARCH setting.  Using sparc64 as ARCH still
> forces 64BIT on.

Hi Bastian.

I have tested the patch and it works as expected.
One small nit below.

	Sam

> 
> Inspired by the x86 and s390 configs.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> 
> -- 
> You can't evaluate a man by logic alone.
> 		-- McCoy, "I, Mudd", stardate 4513.3

> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 0a94d9c..73ddfd9 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -4,6 +4,13 @@
>  
>  mainmenu "Linux/SPARC Kernel Configuration"
>  
> +config 64BIT
> +	bool "64-bit kernel" if ARCH = "sparc"
> +	default ARCH = "sparc64"
> +	help
> +	  Say yes to build a 64-bit kernel - formerly known as sparc64
> +	  Say no to build a 32-bit kernel - formerly known as sparc

We should update this help escription with something remotely like this:

> +	  SPARC is a family of RISC microprocessors designed and marketed by
> +	  Sun Microsystems, incorporated.  They are very widely found in Sun
> +	  workstations and clones.

Just a raw copy from the (always hidden) help text for SPARC32.

	Sam
