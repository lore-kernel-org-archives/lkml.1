Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXHBL6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXHBL6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXHBL55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:57:57 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:38147 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbXHBL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:57:56 -0400
Date: Thu, 2 Aug 2007 12:57:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: trenn@suse.de, Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Message-ID: <20070802115743.GB29735@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <200708021145.09377.adrian@suse.de> <1186048701.18821.459.camel@queen.suse.de> <20070802120221.5474e732@the-village.bc.nu> <20070802111327.GA29002@srcf.ucam.org> <20070802125947.4a1ff933@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802125947.4a1ff933@the-village.bc.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:59:47PM +0100, Alan Cox wrote:
> > I strongly suspect that the vast majority[1] of hardware that "needs" 
> > the trip points changing works perfectly well under Windows, so it's 
> 
> Windows as I understand it has vendor mechanisms to allow the bits
> shipped with the OS to override/ignore just about everything trip points
> included. Lots of hardware that requires fixups in Linux and just works
> in Windows is not Linux bugs but Windows magic .inf files and other
> registry gunge done by the machine vendor. We see this in ATA, in power
> management and elsewhere.

I've seen no evidence that this happens with thermal trip points.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
