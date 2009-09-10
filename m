Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZIJVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZIJVDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZIJVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:03:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZIJVDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:03:16 -0400
Date: Thu, 10 Sep 2009 14:00:47 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>
Subject: Re: [patch] Staging: hv: Add new tasks to the TODO file
Message-ID: <20090910210046.GC3376@suse.de>
References: <1FB5E1D5CA062146B38059374562DF720B8E1E77@TK5EX14MBXC130.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF720B8E1E77@TK5EX14MBXC130.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 08:49:56PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Add new tasks to the TODO file.
> 
> Cc: Hank Janssen <hjanssen@microsoft.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> diff --git a/drivers/staging/hv/TODO b/drivers/staging/hv/TODO
> index fc754ab..345a59f 100644
> --- a/drivers/staging/hv/TODO
> +++ b/drivers/staging/hv/TODO
> @@ -11,6 +11,12 @@ TODO:
>         - audit the network driver
>         - audit the block driver
>         - audit the scsi driver
> +       - SMP Support
> +       - Remote Shutdown
> +       - Networking . Jumbo Frames
> +       - Hot swappable storage devices
> +       - Time Synchronization
> +       - Key Value Pair Exchange

No, sorry, I'm not going to take this.

The TODO file is for what needs to be done to the code in order to get
it _out_ of the staging tree.  Not new features.  This should be a list
of things that people can help you out with, which none of these are,
given the lack of documentation on how adding this to the code is able
to be done.

So please, work on removing the items on the TODO list, that way the
code can then be merged into the main portion of the kernel tree.  Then
you can go and add new features.  There's lots that still needs to be
done with this code before you can think about adding anything new.

thanks,

greg k-h
