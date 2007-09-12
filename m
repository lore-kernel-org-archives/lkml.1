Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbXILVvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbXILVvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXILVuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:50:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42684 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbXILVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:50:55 -0400
Date: Wed, 12 Sep 2007 14:53:56 -0700
From: Greg KH <greg@kroah.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kees Cook <kees@ubuntu.com>,
       linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>,
       Michael Wu <flamingice@sourmilk.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
Message-ID: <20070912215356.GC23294@kroah.com>
References: <20070912064134.GO7910@outflux.net> <46E7C91D.3070001@garzik.org> <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 03:48:49PM +0400, Alexey Dobriyan wrote:
> On 9/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> > Kees Cook wrote:
> > > This patch against 2.6.23-rc6 fixes a couple drivers that do not
> > > correctly terminate their pci_device_id lists.  This results in garbage
> > > being spewed into modules.pcimap when the module happens to not have
> > > 28 NULL bytes following the table, and/or the last PCI ID is actually
> > > truncated from the table when calculating the modules.alias PCI aliases,
> > > cause those unfortunate device IDs to not auto-load.
> > >
> > > Signed-off-by: Kees Cook <kees@ubuntu.com>
> >
> > ACK
> 
> I mut say, non-terminated PCI ids lists are constant PITA. There should be
> a way to a) put it in macro[1], so that terminator automatically added, and
> b) still allow #ifdef inside table like, e.g. 8139too does.
> 
> [1] or not macro, because #ifdef inside macros aren't allowed.

If you know of a way to do this in an easier manner, patches are always
gladly accepted :)

thanks,

greg k-h
