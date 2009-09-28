Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbZI1WSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbZI1WSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZI1WSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:18:35 -0400
Received: from mail.perches.com ([173.55.12.10]:1249 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbZI1WSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:18:35 -0400
Subject: Re: Updated: [PATCH] staging: comedi: CodingStyle cleanup for
 drivers/acl7225b.c
From: Joe Perches <joe@perches.com>
To: Bruce Jones <brucej97223@gmail.com>
Cc: gregkh@suse.de, wfp5@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4AC1343D.3040606@gmail.com>
References: <4AC1343D.3040606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Sep 2009 15:18:38 -0700
Message-Id: <1254176318.28232.388.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 15:10 -0700, Bruce Jones wrote:
> Cleanup the printk's in this driver to use KERN_foo log
> levels.
> +	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
>  	       this_board->name, iobase);
>  	if (!request_region(iobase, iorange, "acl7225b")) {
> -		printk("I/O port conflict\n");
> +		printk(KERN_CONT "I/O port conflict\n");

This should not be KERN_CONT but KERN_INFO or KERN_ERR
and should probably have a "comedi%d:" leader.

Maybe:
	printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n");

cheers, Joe

