Return-Path: <linux-kernel-owner+w=401wt.eu-S939419AbXHIMdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939419AbXHIMdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbXHIMdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:33:12 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:58714 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbXHIMdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:33:11 -0400
Date: Thu, 9 Aug 2007 13:32:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Bryan Wu <bryan.wu@analog.com>, "H.PeterAnvin" <hpa@zytor.com>,
       Greg Ungerer <gerg@uclinux.org>, Kumar Gala <galak@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] Add missing KERN_<level> to multiline
	printk(KERN_<level>...)
Message-ID: <20070809123241.GA12818@linux-mips.org>
References: <1186619327.3073.57.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186619327.3073.57.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 05:28:46PM -0700, Joe Perches wrote:

> Some uses of printk are missing KERN_<level> on the second
> and subsequent lines.
> 
> For instance:
> 
> printk(KERN_INFO "line1: %d\nline2: %d\n", val1, val2);
> 
> Line1 is marked log_level: info
> Line2 is marked log_level: unknown
> 
> Some lines have trailing spaces after \n, removed where appropriate.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

For the MIPS bits.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

But not without the note that mentioned printk should be deleted because
this is not Windows 95.

  Ralf
