Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXFIIDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXFIIDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbXFIICt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:02:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756237AbXFIICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:02:48 -0400
Date: Sat, 09 Jun 2007 01:02:49 -0700 (PDT)
Message-Id: <20070609.010249.77260306.davem@davemloft.net>
To: grundler@parisc-linux.org
Cc: auke-jan.h.kok@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de
Subject: Re: [PATCH 1/2] [RFC] PCI: read revision ID by default
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070609065953.GA1747@colo.lackof.org>
References: <20070608224630.31777.17807.stgit@localhost.localdomain>
	<20070609065953.GA1747@colo.lackof.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@parisc-linux.org>
Date: Sat, 9 Jun 2007 00:59:53 -0600

> On Fri, Jun 08, 2007 at 03:46:30PM -0700, Auke Kok wrote:
> > Currently there are 97 occurrences where drivers need the pci
> > revision ID. We can do this once for all devices. Even the pci
> > subsystem needs the revision several times for quirks. The extra
> > u8 member pads out nicely in the pci_dev struct.
> 
> Good idea. I always wondered why we read the invariants so often
> in the code.

BTW, if you add code like this, you also have to add the
appropriate code to do this for all the platforms that probe
the PCI bus using a firmware device tree like sparc64
and powerpc do.
