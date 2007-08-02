Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXHBP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXHBP6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbXHBP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:58:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4894 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755797AbXHBP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:58:08 -0400
Date: Thu, 2 Aug 2007 15:57:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802155753.GB3974@ucw.cz>
References: <46B1988C.3090302@t-online.de> <20070802015248.45a40717.akpm@linux-foundation.org> <p731wemnre6.fsf@bingen.suse.de> <20070802120014.1d08830a@the-village.bc.nu> <20070802120511.GA440@one.firstfloor.org> <20070802140442.62c56dbd@the-village.bc.nu> <20070802131622.GA1234@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802131622.GA1234@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-08-02 15:16:22, Andi Kleen wrote:
> On Thu, Aug 02, 2007 at 02:04:42PM +0100, Alan Cox wrote:
> > > > Set a taint flag, 
> > > That's hardly any useful if the machine is dead afterwards.
> > 
> > It won't be the hardware will do a failsafe shutdown first.
> 
> Not necessarily. At SUSE we had at least one broken laptop
> with wrong trip points. The machine ran very hot for some time
> and afterwards the hard disk was dead.

Yes, but it was original BIOS trip points that were wrong. And yes,
its failsafe shutdown was too late. At least lowering the trip points
would allow me to run it safely.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
