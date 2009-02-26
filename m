Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZBZU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZBZU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbZBZU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:26:04 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:34159 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZBZU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:26:02 -0500
Date: Thu, 26 Feb 2009 12:25:58 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jan-Bernd Themann <THEMANN@de.ibm.com>
Subject: Re: [RFC v2] virtio: add virtio-over-PCI driver
Message-ID: <20090226202558.GB19523@ovro.caltech.edu>
References: <20090224000002.GA578@ovro.caltech.edu> <200902261715.28440.arnd@arndb.de> <alpine.LRH.2.00.0902261752310.29190@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902261752310.29190@vixen.sonytel.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 26 Feb 2009 12:25:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 05:53:56PM +0100, Geert Uytterhoeven wrote:
> On Thu, 26 Feb 2009, Arnd Bergmann wrote:
> > On Tuesday 24 February 2009, Ira Snyder wrote:
> > > +/* Virtio-over-PCI descriptors: 12 bytes. These can chain together via "next" */
> > > +struct vop_desc {
> > > +	/* Address (host physical) */
> > > +	__le32 addr;
>                ^^^^
> Only 32-bit? Is this future-proof?
> 

Probably not. If I use __le64 instead, how do I write 64 bytes over the
PCI bus? There isn't an iowrite64()/ioread64() anywhere in Linux.

Thanks,
Ira
