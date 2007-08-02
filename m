Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXHBNQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXHBNQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXHBNQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:16:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbXHBNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:16:24 -0400
Date: Thu, 2 Aug 2007 15:16:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       trenn@suse.de, pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802131622.GA1234@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de> <20070802015248.45a40717.akpm@linux-foundation.org> <p731wemnre6.fsf@bingen.suse.de> <20070802120014.1d08830a@the-village.bc.nu> <20070802120511.GA440@one.firstfloor.org> <20070802140442.62c56dbd@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802140442.62c56dbd@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:04:42PM +0100, Alan Cox wrote:
> > > Set a taint flag, 
> > That's hardly any useful if the machine is dead afterwards.
> 
> It won't be the hardware will do a failsafe shutdown first.

Not necessarily. At SUSE we had at least one broken laptop
with wrong trip points. The machine ran very hot for some time
and afterwards the hard disk was dead.

-Andi
