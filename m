Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZKQS2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZKQS2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZKQS2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:28:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56591 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbZKQS2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:28:11 -0500
Date: Tue, 17 Nov 2009 18:29:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] sep: fix 2 warnings
Message-ID: <20091117182927.16614250@lxorguk.ukuu.org.uk>
In-Reply-To: <20091117101742.d512100e.randy.dunlap@oracle.com>
References: <20091117195309.6cc3ead0.sfr@canb.auug.org.au>
	<20091117101742.d512100e.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 10:17:42 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warning:
> drivers/staging/sep/sep_driver.c:276: warning: format '%08llx' expects type 'long long unsigned int', but argument 2 has type 'dma_addr_t'
> 
> and variable may be used uninitialized (correct):
> drivers/staging/sep/sep_driver.c:1774: warning: 'error' may be used uninitialized in this function
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Alan Cox <alan@linux.intel.com>
