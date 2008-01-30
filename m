Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYA3QPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYA3QPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 11:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYA3QP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 11:15:26 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:18598 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYA3QPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 11:15:25 -0500
Date: Wed, 30 Jan 2008 08:08:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: Spelling/grammar fixes for config
 DEBUG_SECTION_MISMATCH
Message-Id: <20080130080811.eefbee51.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0801301112550.26678@vixen.sonytel.be>
References: <Pine.LNX.4.64.0801301112550.26678@vixen.sonytel.be>
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

On Wed, 30 Jan 2008 11:13:23 +0100 (CET) Geert Uytterhoeven wrote:

> kbuild: Spelling/grammar fixes for config DEBUG_SECTION_MISMATCH
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  lib/Kconfig.debug |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -90,19 +90,19 @@ config DEBUG_SECTION_MISMATCH
>  	  most likely result in an oops.
>  	  In the code functions and variables are annotated with
>  	  __init, __devinit etc. (see full list in include/linux/init.h)
> -	  which result in the code/data being placed in specific sections.
> -	  The section mismatch anaylsis are always done after a full
> +	  which results in the code/data being placed in specific sections.
> +	  The section mismatch analysis is always done after a full
>  	  kernel build but enabling this options will in addition

	                                 option

>  	  do the following:
>  	  - Add the option -fno-inline-functions-called-once to gcc
>  	    When inlining a function annotated __init in a non-init
>  	    function we would loose the section information and thus

	                      lose

>  	    the analysis would not catch the illegal reference.
> -	    This options tell gcc to inline less but will also
> +	    This option tells gcc to inline less but will also
>  	    result in a larger kernel.
>  	  - Run the section mismatch analysis for each module/built-in.o
>  	    When we run the section mismatch analysis on vmlinux.o we
> -	    looses valueable information about where the mismatch was
> +	    loose valueable information about where the mismatch was

	    lose valuable

>  	    introduced.
>  	    Running the analysis for each module/built-in.o file
>  	    will tell where the mismatch happens much closer to the

Thanks.  I had a note to myself to do this as well.

---
~Randy
