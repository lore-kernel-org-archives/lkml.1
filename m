Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbZFMPDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbZFMPDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZFMPDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 11:03:39 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:56471 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZFMPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 11:03:39 -0400
Date: Sat, 13 Jun 2009 11:01:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, ysato@users.sourceforge.jp
Subject: Re: [PATCH] H8/300:  Correct Kconfig "select"s by dropping CONFIG_
 prefix.
In-Reply-To: <alpine.LFD.2.00.0906131053270.19255@localhost>
Message-ID: <alpine.LFD.2.00.0906131059570.20669@localhost>
References: <alpine.LFD.2.00.0906131053270.19255@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  whoops, ignore, there's another problem in this Kconfig file...

On Sat, 13 Jun 2009, Robert P. J. Day wrote:

> Kconfig "select" directives shouldn't use a "CONFIG_" prefix.
>
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> ---
>
> diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
> index b65dcfe..038637a 100644
> --- a/arch/h8300/Kconfig.cpu
> +++ b/arch/h8300/Kconfig.cpu
> @@ -13,7 +13,7 @@ config H8300H_GENERIC
>
>  config H8300H_AKI3068NET
>  	bool "AE-3068/69"
> -	select CONFIG_H83068
> +	select H83068
>  	help
>  	  AKI-H8/3068F / AKI-H8/3069F Flashmicom LAN Board Support
>  	  More Information. (Japanese Only)
> @@ -24,7 +24,7 @@ config H8300H_AKI3068NET
>
>  config H8300H_H8MAX
>  	bool "H8MAX"
> -	select CONFIG_H83068
> +	select H83068
>  	help
>  	  H8MAX Evaluation Board Support
>  	  More Information. (Japanese Only)
> @@ -32,7 +32,7 @@ config H8300H_H8MAX
>
>  config H8300H_SIM
>  	bool "H8/300H Simulator"
> -	select CONFIG_H83007
> +	select H83007
>  	help
>  	  GDB Simulator Support
>  	  More Information.
> @@ -45,7 +45,7 @@ config H8S_GENERIC
>
>  config H8S_EDOSK2674
>  	bool "EDOSK-2674"
> -	select CONFIG_H8S2768
> +	select H8S2768

  that's a separate typo, should actually be "H8S2678", to match the
later "config" directive.  ignore this.  sorry.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
