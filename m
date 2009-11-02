Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZKBPtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZKBPtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZKBPtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:49:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:34288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZKBPtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:49:01 -0500
Date: Mon, 2 Nov 2009 16:49:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: remove pci_find_slot from PCI_LEGACY config
 description
In-Reply-To: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0911021648320.4203@wotan.suse.de>
References: <1256932009-5905-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Commit 3b073eda has removed pci_find_slot, so there's no point in
> mentioning it in the config description as one of the deprecated APIs
> there are enabled by PCI_LEGACY and still used by some drivers.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/pci/Kconfig |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index fdc864f..48a3ea7 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -27,10 +27,10 @@ config PCI_LEGACY
>  	default y
>  	help
>  	  Say Y here if you want to include support for the deprecated
> -	  pci_find_slot() and pci_find_device() APIs.  Most drivers have
> -	  been converted over to using the proper hotplug APIs, so this
> -	  option serves to include/exclude only a few drivers that are
> -	  still using this API.
> +	  pci_find_device() API.  Most drivers have been converted over
> +	  to using the proper hotplug APIs, so this option serves to
> +	  include/exclude only a few drivers that are still using this
> +	  API.

While you are at it, how about removing the references in 
Documentation/PCI/pci.txt as well?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
