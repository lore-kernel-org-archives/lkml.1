Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZG2AQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZG2AQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZG2AQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:16:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26002 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZG2AQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:16:13 -0400
Date: Tue, 28 Jul 2009 18:16:13 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: [PATCH] Shut off pci_find_device warnings when the deprecated
	pci functions are enabled.
Message-ID: <20090729001613.GA19369@ldl.fc.hp.com>
References: <20090724094115.GA18450@basil.fritz.box> <20090728095552.72c41525@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728095552.72c41525@jbarnes-g45>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jesse.barnes@intel.com>:
> On Fri, 24 Jul 2009 11:41:15 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Shut off pci_find_device warnings when the deprecated pci functions
> > are enabled.
> > 
> > Shut off the long standing
> > 
> > linux/drivers/pci/search.c:144: warning: 'pci_find_device' is
> > deprecated (declared at linux/drivers/pci/search.c:136)
> > linux/drivers/pci/search.c:144: warning: 'pci_find_device' is
> > deprecated (declared at linux/drivers/pci/search.c:136)
> > 
> > warnings that appear on every build when CONFIG_PCI_LEGACY is enabled.
> > 
> > gcc warns for the use in EXPORT_SYMBOL
> > 
> > I moved these to a separate file and disabled the warning in the
> > Makefile for that file.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Applied to linux-next, thanks.

Maybe it's too late now, but I thought those warnings were
supposed to motivate people to convert old, buggy drivers to get
off the deprecated interface.

That's what finally motivated me to get rid of pci_find_slot()
earlier...

By the way, this would also be a perfect kernelnewbies/kernel
janitor cleanup, as it would require actually digging into
drivers and making real, substantial changes as opposed to
whitespace/checkpatch/typo patches.

Just a thought.

/ac

