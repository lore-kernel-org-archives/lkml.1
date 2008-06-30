Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbYF3VAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbYF3VAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbYF3VAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:00:22 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:43592 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753662AbYF3VAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:00:21 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] PCI: add stub for pci_set_consistent_dma_mask()
Date: Mon, 30 Jun 2008 14:00:02 -0700
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-pci@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@hansenpartnership.com>,
       akpm <akpm@linux-foundation.org>
References: <20080630113553.c133307f.randy.dunlap@oracle.com> <200806301142.31124.jbarnes@virtuousgeek.org> <200806302240.50416.mb@bu3sch.de>
In-Reply-To: <200806302240.50416.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806301400.02455.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2008 1:40 pm Michael Buesch wrote:
> On Monday 30 June 2008 20:42:30 Jesse Barnes wrote:
> > On Monday, June 30, 2008 11:35 am Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > > When CONFIG_PCI=n, there is no stub for pci_set_consistent_dma_mask(),
> > > so add one like other similar stubs.  Otherwise there can be build
> > > errors, as here:
> > >
> > > linux-next-20080630/drivers/ssb/main.c:1175: error: implicit
> > > declaration of function 'pci_set_consistent_dma_mask'
> > >
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Applied to linux-next, thanks Randy.
>
> I guess this is probably also needed for 2.6.26.

Hm, current upstream seems to have pci_set_consistent_dma_mask under 
CONFIG_SSB_PCIHOST, which in turn depends on PCI = y (or PCI = SSB, what does 
that mean?).

But yeah, it wouldn't hurt to push this for 2.6.26 too.

Jesse
