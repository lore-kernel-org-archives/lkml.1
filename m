Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbXGRPq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbXGRPq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759841AbXGRPqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:46:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923AbXGRPqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:46:47 -0400
Date: Tue, 17 Jul 2007 19:46:37 -0700
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
	warnings
Message-ID: <20070718024637.GC6146@suse.de>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717214239.GF28448@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 05:42:39PM -0400, Jeff Garzik wrote:
> commit ae97fec3701a559929c3529e35417fab133a4d39
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Tue Jul 17 01:08:29 2007 -0400
> 
>     drivers/usb/misc/auerswald: fix status check, remove redundant check
>     
>     1) We should only set 'actual_length' output variable if usb length is
>     known to be good.
>     
>     2) No need to check actual_length for NULL.  The only caller always
>     passes non-NULL value.
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

I have no objection to this patch at all, however it does not remove the
compiler warning :(

thanks,

greg k-h
