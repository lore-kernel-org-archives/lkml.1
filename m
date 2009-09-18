Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZIRQiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZIRQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZIRQix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:38:53 -0400
Received: from fifo99.com ([67.223.236.141]:55284 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZIRQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:38:53 -0400
Subject: Re: [PATCH] Add uboot commandline argument passing support to
 m68knommu
From: Daniel Walker <dwalker@fifo99.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org
In-Reply-To: <20090918162736.GY23700@csclub.uwaterloo.ca>
References: <20090918162736.GY23700@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 09:39:04 -0700
Message-Id: <1253291944.7060.42.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 12:27 -0400, Lennart Sorensen wrote:
> +
> +       if (uboot_cmd_start && uboot_cmd_end) {
> +               strncpy(commandp, (const char *)uboot_cmd_start,
> size);
> +       }
> +#if defined(CONFIG_BLK_DEV_INITRD)
> +       if (uboot_initrd_start && uboot_initrd_end && 
> +               (uboot_initrd_end > uboot_initrd_start))
> {              
> +               initrd_start = uboot_initrd_start;
> +               initrd_end = uboot_initrd_end;
> +               ROOT_DEV = Root_RAM0;
> +               printk("initrd at 0x%lx:0x%lx\n", 
> +                       initrd_start, initrd_end);
> +       }
> +#endif /* if defined(CONFIG_BLK_DEV_INITRD) */
> +}

You have a couple of various checkpatch errors in this patch. We use
scripts/checkpatch.pl to check for code style issues. Could you run that
on your patch and fix any errors it finds? A couple are whitespace
related and you can use scripts/cleanpatch or scripts/cleanfile to
remove whitespace (so I hear. I've never run those scripts personally)

Daniel

