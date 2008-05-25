Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYEYWqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYEYWqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 18:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYEYWp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 18:45:58 -0400
Received: from colo.lackof.org ([198.49.126.79]:35086 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYEYWp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 18:45:57 -0400
Date: Sun, 25 May 2008 16:45:42 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: early dump pci conf space v3
Message-ID: <20080525224542.GB22343@colo.lackof.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com> <200805231248.55345.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805231248.55345.yhlu.kernel@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 12:48:54PM -0700, Yinghai Lu wrote:
> 
> so we can printout pci config before kernel touch it
> v3: change to pci=early_config_dump
...
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -1570,6 +1570,8 @@ and is between 256 and 4096 characters. 
>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>  				reserved for the CardBus bridge's memory
>  				window. The default value is 64 megabytes.
> +		early_config_dump	[X86] print out pci config space
> +				registers early before kernel touch any

A bit of wordsmithing here:

		early_config_dump	[X86] print out pci config space
					registers before the kernel touches
					any PCI resources. This can help
					determine what PCI quirks need to
					do to compensate for broken BIOS.

Rest of the patch:
Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant
