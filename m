Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYE2TTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYE2TTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYE2TTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:19:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35012 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYE2TTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:19:43 -0400
Date: Thu, 29 May 2008 12:06:06 -0700
From: Greg KH <greg@kroah.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux390@de.ibm.com,
       apw@shadowen.org
Subject: Re: [PATCH] linux-next: Tree for May 29 - build failure s390x
	-typo in ccw_timeout_log()
Message-ID: <20080529190606.GE22414@kroah.com>
References: <20080529182556.2994310a.sfr@canb.auug.org.au> <20080529182824.GA11679@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529182824.GA11679@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:58:24PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The next-20080529 kernel build fails on the s390x, with the error
> 
> drivers/s390/cio/device_fsm.c: In function `ccw_timeout_log':
> drivers/s390/cio/device_fsm.c:55: error: syntax error before ';' token
> drivers/s390/cio/device_fsm.c:56: error: syntax error before ';' token
> make[2]: *** [drivers/s390/cio/device_fsm.o] Error 1
> make[1]: *** [drivers/s390/cio] Error 2
> make: *** [drivers/s390] Error 2
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.26-rc4/drivers/s390/cio/device_fsm.c	2008-05-29 23:24:32.000000000 +0530
> +++ linux-2.6.26-rc4/drivers/s390/cio/~device_fsm.c	2008-05-29 23:29:42.000000000 +0530
> @@ -52,8 +52,8 @@ static void ccw_timeout_log(struct ccw_d
>  	printk(KERN_WARNING "cio: orb:\n");
>  	print_hex_dump(KERN_WARNING, "cio:  ", DUMP_PREFIX_NONE, 16, 1,
>  		       orb, sizeof(*orb), 0);
> -	printk(KERN_WARNING "cio: ccw device bus id: %s\n", dev_name(&cdev->dev);
> -	printk(KERN_WARNING "cio: subchannel bus id: %s\n", dev_name(&sch->dev);
> +	printk(KERN_WARNING "cio: ccw device bus id: %s\n", dev_name(&cdev->dev));
> +	printk(KERN_WARNING "cio: subchannel bus id: %s\n", dev_name(&sch->dev));
>  	printk(KERN_WARNING "cio: subchannel lpm: %02x, opm: %02x, "
>  	       "vpm: %02x\n", sch->lpm, sch->opm, sch->vpm);

Already fixed in my tree, sorry about this.

greg k-h
