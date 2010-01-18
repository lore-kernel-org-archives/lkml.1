Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606Ab0ARMaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0ARMaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327Ab0ARMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:30:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:53666 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab0ARMaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:30:00 -0500
Message-ID: <4B545445.1070308@suse.cz>
Date: Mon, 18 Jan 2010 13:29:57 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?UTF-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile: Document ability to make file.lst and file.S
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com>	 <20100113115617.GA24818@basil.fritz.box> <4B4DE887.6030602@gmail.com>	 <20100113155323.GB24818@basil.fritz.box>	 <1263400835.8011.73.camel@Joe-Laptop.home>	 <20100113171411.GC24818@basil.fritz.box> <1263403904.8011.83.camel@Joe-Laptop.home>
In-Reply-To: <1263403904.8011.83.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.1.2010 18:31, Joe Perches wrote:
> Then that might as well go into the help.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> diff --git a/Makefile b/Makefile
> index 9f64552..484cff4 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1248,7 +1248,9 @@ help:
>  	@echo  '  firmware_install- Install all firmware to INSTALL_FW_PATH'
>  	@echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
>  	@echo  '  dir/            - Build all files in dir and below'
> -	@echo  '  dir/file.[ois]  - Build specified target only'
> +	@echo  '  dir/file.[oisS] - Build specified target only'
> +	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
> +	@echo  '                    (requires a recent binutils and recent build (System.map))'

Applied, thanks.

Michal
