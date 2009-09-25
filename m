Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZIYJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZIYJt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZIYJty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:49:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52900 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZIYJtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:49:53 -0400
Date: Fri, 25 Sep 2009 12:48:02 +0300
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: ext Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: fix htmldocs pci.c
Message-ID: <20090925094802.GB2854@cachaca>
Reply-To: tiago.vignatti@nokia.com
References: <1253798147.10654.3.camel@ht.satnam> <4ABB9627.9040708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABB9627.9040708@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 25 Sep 2009 09:48:02.0405 (UTC) FILETIME=[45E64150:01CA3DC5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 05:54:15PM +0200, ext Randy Dunlap wrote:
> Jaswinder Singh Rajput wrote:
> > Fix the following htmldocs warnings:
> > 
> >   Warning(drivers/pci/pci.c:2552): No description found for parameter 'dev'
> >   Warning(drivers/pci/pci.c:2552): No description found for parameter 'decode'
> >   Warning(drivers/pci/pci.c:2552): No description found for parameter 'command_bits'
> >   Warning(drivers/pci/pci.c:2552): No description found for parameter 'change_bridge'
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Ack, but already sent to Jesse & linux-pci mailing list.

got my Ack also.
 
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  drivers/pci/pci.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 6edecff..67288ec 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2542,10 +2542,10 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
> >  
> >  /**
> >   * pci_set_vga_state - set VGA decode state on device and parents if requested
> > - * @dev the PCI device
> > - * @decode - true = enable decoding, false = disable decoding
> > - * @command_bits PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
> > - * @change_bridge - traverse ancestors and change bridges
> > + * @dev: the PCI device
> > + * @decode: true = enable decoding, false = disable decoding
> > + * @command_bits: PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
> > + * @change_bridge: traverse ancestors and change bridges
> >   */
> >  int pci_set_vga_state(struct pci_dev *dev, bool decode,
> >  		      unsigned int command_bits, bool change_bridge)
            Tiago
