Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbXHBSkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbXHBSkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbXHBSka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:40:30 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:39276 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760126AbXHBSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:40:29 -0400
Date: Thu, 2 Aug 2007 19:40:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, lenb@kernel.org
Message-ID: <20070802184013.GA4047@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de> <20070802015248.45a40717.akpm@linux-foundation.org> <p731wemnre6.fsf@bingen.suse.de> <20070802120014.1d08830a@the-village.bc.nu> <20070802120511.GA440@one.firstfloor.org> <20070802140442.62c56dbd@the-village.bc.nu> <20070802131622.GA1234@one.firstfloor.org> <20070802155753.GB3974@ucw.cz> <20070802183830.GA4192@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802183830.GA4192@one.firstfloor.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.22 regression: thermal trip points
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 08:38:30PM +0200, Andi Kleen wrote:
> On Thu, Aug 02, 2007 at 03:57:54PM +0000, Pavel Machek wrote:
> > Yes, but it was original BIOS trip points that were wrong. And yes,
> > its failsafe shutdown was too late. At least lowering the trip points
> > would allow me to run it safely.
> 
> I have no problem with lowering them (in fact I proposed this
> to Thomas as a possible solution at some point). Just rising 
> is a bad idea.

Though for this to be reliable, you need to ignore any notifications 
that would raise the trip points while still paying attention to any 
that would lower them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
