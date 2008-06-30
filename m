Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbYF3Ul3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbYF3Ul3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYF3UlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:41:21 -0400
Received: from bu3sch.de ([62.75.166.246]:35070 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYF3UlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:41:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI: add stub for pci_set_consistent_dma_mask()
Date: Mon, 30 Jun 2008 22:40:50 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-pci@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@hansenpartnership.com>,
       akpm <akpm@linux-foundation.org>
References: <20080630113553.c133307f.randy.dunlap@oracle.com> <200806301142.31124.jbarnes@virtuousgeek.org>
In-Reply-To: <200806301142.31124.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806302240.50416.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 20:42:30 Jesse Barnes wrote:
> On Monday, June 30, 2008 11:35 am Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > When CONFIG_PCI=n, there is no stub for pci_set_consistent_dma_mask(),
> > so add one like other similar stubs.  Otherwise there can be build errors,
> > as here:
> >
> > linux-next-20080630/drivers/ssb/main.c:1175: error: implicit declaration of
> > function 'pci_set_consistent_dma_mask'
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Applied to linux-next, thanks Randy.

I guess this is probably also needed for 2.6.26.

-- 
Greetings Michael.
