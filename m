Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZAaDPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZAaDPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760553AbZAaDPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:15:22 -0500
Received: from kroah.org ([198.145.64.141]:49640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758526AbZAaDPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:15:21 -0500
Date: Fri, 30 Jan 2009 19:11:23 -0800
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: stable@kernel.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [stable] For -stable: sata_mv: fix 8-port timeouts on
	508x/6081 chips
Message-ID: <20090131031123.GA5902@kroah.com>
References: <20090131023906.GA12147@kroah.com> <4983BE2B.90805@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4983BE2B.90805@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 09:57:47PM -0500, Mark Lord wrote:
> commit b0bccb18bc523d1d5060d25958f12438062829a9
> Author: Mark Lord <liml@rtr.ca>
> Date:   Mon Jan 19 18:04:37 2009 -0500
> 
>     sata_mv: fix 8-port timeouts on 508x/6081 chips
>     
>     Fix a longstanding bug for the 8-port Marvell Sata controllers (508x/6081),
>     where accesses to the upper 4 ports would cause lost-interrupts / timeouts
>     for the lower 4-ports.  With this patch, the 6081 boards should finally be
>     reliable enough for mainstream use with Linux.
>     
>     Signed-off-by: Mark Lord <mlord@pobox.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> 
> This should be backported to all -stable kernels.

Thanks, I'll queue this up for the next releases after these come out.

greg k-h
