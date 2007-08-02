Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbXHBLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbXHBLNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXHBLNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:13:47 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:35960 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbXHBLNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:13:46 -0400
Date: Thu, 2 Aug 2007 12:13:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: trenn@suse.de, Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Message-ID: <20070802111327.GA29002@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de> <1186048701.18821.459.camel@queen.suse.de> <20070802120221.5474e732@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802120221.5474e732@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:02:21PM +0100, Alan Cox wrote:
> > Anyway, only solution/workaround to use these machines with current
> > kernels is to override trip points, maybe the patch should really just
> > be reverted...
> 
> The question really is whether the vendors will all revert it and carry
> it as a patch or whether the main tree will accept reality on this one.
> 
> Reverting it and adding a taint marker if you do it is much preferable I
> suspect to having every vendor revert this bogus if well meaning
> changeset.

I strongly suspect that the vast majority[1] of hardware that "needs" 
the trip points changing works perfectly well under Windows, so it's 
likely to be papering over bugs in the kernel. It'd be nice if we fixed 
those rather than encouraging people to poke stuff into /proc, 
especially when doing so is guaranteed to break in really confusing ways 
with a lot of hardware. The firmware can reset the trip points at 
essentially arbitrary times and is well within its rights to expect the 
OS to actually pay attention to them.

[1] Some hardware is simply broken. We don't carry phc just because some 
vendors put the wrong voltage values in their tables, either
-- 
Matthew Garrett | mjg59@srcf.ucam.org
