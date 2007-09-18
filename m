Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbXIRJyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbXIRJyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbXIRJyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:54:32 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:56352 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbXIRJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:54:31 -0400
Date: Tue, 18 Sep 2007 13:54:31 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070918135431.B26491@jurassic.park.msu.ru>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com> <20070913073140.GA17367@parisc-linux.org> <1189668286.18361.3.camel@sli10-conroe.sh.intel.com> <20070913075536.GB17367@parisc-linux.org> <20070913095313.GA745@suse.de> <20070913151637.A1679@jurassic.park.msu.ru> <1189972912.6403.16.camel@localhost.localdomain> <20070917142241.C21399@jurassic.park.msu.ru> <1190061024.6403.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1190061024.6403.64.camel@localhost.localdomain>; from benh@kernel.crashing.org on Tue, Sep 18, 2007 at 06:30:23AM +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:30:23AM +1000, Benjamin Herrenschmidt wrote:
> At this stage (but we are getting a bit OT), ppc has something like 3
> different PCI code implementations :-) I do have some plans to fix that
> by switching everybody to use pci_assign_unassigned_resources() and
> friends but last time I tried, everything blew up :-) I suspect I'll
> need a quirk or two in the generic code, but I'll let you know when I
> get to it.

Ok, I'll be happy to look into that :-)

Ivan.
