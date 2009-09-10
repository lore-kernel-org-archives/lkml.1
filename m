Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557AbZIJVT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbZIJVT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZIJVTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:19:25 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:25276 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbZIJVTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:19:24 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 17:19:24 EDT
From: Tom Hanrahan <hanrahat@microsoft.com>
To: Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [patch] Staging: hv: Add new tasks to the TODO file
Thread-Topic: [patch] Staging: hv: Add new tasks to the TODO file
Thread-Index: AcoyWEDkXkMdXuS/TzW/xG2oNhanAwAPDBaAAA5I/nA=
Date: Thu, 10 Sep 2009 21:12:44 +0000
Message-ID: <AD02C96F1FB40A4B896D24F974E9B9D402E4F0@TK5EX14MBXC139.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF720B8E1E77@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20090910210046.GC3376@suse.de>
In-Reply-To: <20090910210046.GC3376@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's a fair request.  I concur.

Thanks,

-- Tom

-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Thursday, September 10, 2009 11:01 PM
To: Haiyang Zhang
Cc: Hank Janssen; linux-kernel@vger.kernel.org; Tom Hanrahan
Subject: Re: [patch] Staging: hv: Add new tasks to the TODO file

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

