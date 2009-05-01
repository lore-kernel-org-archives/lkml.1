Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZEAN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZEAN73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758429AbZEAN7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:59:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53196 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbZEAN7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:59:19 -0400
Date: Fri, 1 May 2009 14:59:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>, Matthew Wilcox <willy@linux.intel.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
	question)
Message-ID: <20090501135908.GA17872@srcf.ucam.org>
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu> <20090430113814.GB4809@mit.edu> <49FA55A0.8080303@gmail.com> <20090501025132.GA7275@mit.edu> <49FA78B4.2070900@gmail.com> <20090501113533.GB10704@linux.intel.com> <20090501131459.GA7681@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501131459.GA7681@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:14:59AM -0400, Theodore Tso wrote:

> Oh.... and I suspect I know why they did it; I'm guessing they wanted
> to support PATA Ultrabay devices for backwards compatibility on the
> X60, and perhaps they were running out of connector pins on the
> docking station (the Ultrabay slot is on the X61's "media slice"), and
> they didn't have enough wires to run both PATA and SATA interfaces to
> the docking station, *and* they wanted to use the same docking station
> for the X60 and X61 Thinkpads.

SATA ultrabays have a standard SATA connector, which is in the same 
physical location as the PATA connector on the older bays - it's not 
possible for a single bay to support both PATA and SATA devices. Bear in 
mind that the usual use for one of these bays is for optical drives, and 
SATA slimline drives have only started appearing recently.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
