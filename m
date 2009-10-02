Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZJBXrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZJBXrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 19:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZJBXrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 19:47:13 -0400
Received: from kroah.org ([198.145.64.141]:38544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbZJBXqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 19:46:25 -0400
Date: Fri, 2 Oct 2009 15:16:36 -0700
From: Greg KH <greg@kroah.com>
To: Bruce Jones <brucej97223@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, wfp5@virginia.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: CodingStyle cleanup for
 drivers/acl722b.c
Message-ID: <20091002221636.GE32440@kroah.com>
References: <4AC12685.5030002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC12685.5030002@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 02:11:33PM -0700, Bruce Jones wrote:
> Cleanup this file as per the coding style.  Adding KERN_INFO to
> the printks.
> 
> Signed-off-by: Bruce Jones <brucej@linux.com>
> ---
>  drivers/staging/comedi/drivers/acl7225b.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
> index c3652ef..e6c6c87 100644
> --- a/drivers/staging/comedi/drivers/acl7225b.c
> +++ b/drivers/staging/comedi/drivers/acl7225b.c
> @@ -94,7 +94,7 @@ static int acl7225b_attach(struct comedi_device *dev,
>  
>  	iobase = it->options[0];
>  	iorange = this_board->io_range;
> -	printk("comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
> +	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
>  	       this_board->name, iobase);
>  	if (!request_region(iobase, iorange, "acl7225b")) {
>  		printk("I/O port conflict\n");
> @@ -137,14 +137,14 @@ static int acl7225b_attach(struct comedi_device *dev,
>  	s->range_table = &range_digital;
>  	s->private = (void *)ACL7225_DI_LO;
>  
> -	printk("\n");
> +	printk(KERN_INFO "\n");

Oh nevermind, I took your later patch, sorry for the confusion.

greg k-h
