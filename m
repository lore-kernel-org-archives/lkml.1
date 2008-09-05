Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYIEQ2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYIEQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYIEQ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:28:39 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:45239 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYIEQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:28:38 -0400
Date: Fri, 5 Sep 2008 12:28:31 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
Message-ID: <20080905162831.GA13801@phobos.i.cabal.ca>
References: <1213696004.26255.960.camel@pmac.infradead.org> <1220632021.2985.360.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220632021.2985.360.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 05:27:01PM +0100, David Woodhouse wrote:
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index a7d4fd3..8313fcc 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -76,9 +76,6 @@ config IRQ_PER_CPU
>  	bool
>  	default y
>  
> -config ARCH_SUPPORTS_AOUT
> -	def_bool y
> -
>  # unless you want to implement ACPI on PA-RISC ... ;-)
>  config PM
>  	bool

This isn't even correct. PA-RISC only supports SOM or ELF...
