Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZGMQ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZGMQ0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 12:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZGMQ0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 12:26:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525AbZGMQ0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 12:26:02 -0400
Date: Mon, 13 Jul 2009 09:25:11 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 13 (staging/usbip)
Message-ID: <20090713162511.GB22074@suse.de>
References: <20090713180524.72f613dc.sfr@canb.auug.org.au>
 <20090713085915.6bbd4879.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713085915.6bbd4879.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 08:59:15AM -0700, Randy Dunlap wrote:
> On Mon, 13 Jul 2009 18:05:24 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20090710:
> 
> 
> drivers/staging/usbip/usbip_common.c: In function 'usbip_thread':
> drivers/staging/usbip/usbip_common.c:386: error: implicit declaration of function 'lock_kernel'
> drivers/staging/usbip/usbip_common.c:390: error: implicit declaration of function 'unlock_kernel'
> 
> config attached.

Odd, that code has not changed at all.

Did we just loose the big kernel lock somehow?

thanks,

greg k-h
