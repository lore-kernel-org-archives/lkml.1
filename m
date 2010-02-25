Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934729Ab0BZANm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:13:42 -0500
Received: from kroah.org ([198.145.64.141]:43489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934703Ab0BZANY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:13:24 -0500
Date: Thu, 25 Feb 2010 15:50:54 -0800
From: Greg KH <greg@kroah.com>
To: Graham M Howe <gman.1352@googlemail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: comedi: fix bracing and kfree issue in
 ni_670x.c This is a patch to the ni_670x.c file that fixes up brace and
 kfree issue found by checkpatch.pl tool Signed-off-by: Graham M
 Howe<gman.1352@googlemail.com>
Message-ID: <20100225235054.GE24155@kroah.com>
References: <1266666781-2178-1-git-send-email-gman.1352@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266666781-2178-1-git-send-email-gman.1352@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject doesn't match what the patch did :(

On Sat, Feb 20, 2010 at 11:53:01AM +0000, Graham M Howe wrote:
> ---
>  drivers/staging/comedi/drivers/ni_670x.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
> index fc5f90f..352b917 100644
> --- a/drivers/staging/comedi/drivers/ni_670x.c
> +++ b/drivers/staging/comedi/drivers/ni_670x.c
> @@ -221,8 +221,6 @@ static int ni_670x_detach(struct comedi_device *dev)
>  {
>  	printk("comedi%d: ni_670x: remove\n", dev->minor);
> 
> -	if (dev->subdevices[0].range_table_list)
> -		kfree(dev->subdevices[0].range_table_list);

You can't just not free the memory :(

greg k-h
