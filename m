Return-Path: <linux-kernel-owner+w=401wt.eu-S2992810AbXCCA5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992810AbXCCA5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992819AbXCCA5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:57:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992810AbXCCA53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:57:29 -0500
Date: Fri, 2 Mar 2007 16:57:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Gary Zambrano <zambrano@broadcom.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] dma-mapping.h
Message-Id: <20070302165723.9eb5ccd1.akpm@linux-foundation.org>
In-Reply-To: <45E8C4B6.4050302@garzik.org>
References: <1171651858.16919.14.camel@dhcp-10-7-81-58.broadcom.com>
	<45E8C4B6.4050302@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 19:43:34 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Gary Zambrano wrote:
> > Added dma_sync_single_range_for_cpu/device to dma-mapping.h in asm-arm &
> > asm-avr32 to call dma_sync_single_for_cpu/device. This patch enables b44
> > to compile on systems with these cpus.
> > This patch was created with the assumption that another method of
> > dma_sync_single_range_for_cpu/device does not exist on these
> > architectures.
> > 
> > 
> > Signed-off by: Gary Zambrano <zambrano@broadcom.com>
> 
> this patch looks OK to me, but I'm not the one to apply it.  This should 
> go through Andrew or linux-arch
> 

yeah, I split this into separate arm and avr32 patches and queued them up a while
back.  I need to send them off to Russell and Haavard.  But I'm a bit sluggish
about forwarding things to the subsystem maintainers.  Perhaps because the
resutls are so disappointing ;)

