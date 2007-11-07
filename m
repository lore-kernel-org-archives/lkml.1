Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbXKGUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbXKGUiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXKGUiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:38:04 -0500
Received: from mx1.suse.de ([195.135.220.2]:39079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbXKGUiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:38:03 -0500
Date: Wed, 7 Nov 2007 12:39:18 -0800
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 build failure
	init/do_mount
Message-ID: <20071107203918.GA10007@suse.de>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org> <473205D2.3080703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473205D2.3080703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 12:07:06AM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails with randconfig, with folllowing error
> 
> init/do_mounts.c: In function ‘name_to_dev_t’:
> init/do_mounts.c:110: error: implicit declaration of function ‘blk_lookup_devt’
> make[1]: *** [init/do_mounts.o] Error 1
> make: *** [init] Error 2
> 
> This is caused by gregkh-driver-block-device.patch, where the function 
> blk_lookup_devt is declared within #ifdef CONFIG_BLOCK and randconfig has
> not set the CONFIG_BLOCK it.

That patch has been pulled for the next -mm releases.

thanks,

greg k-h
