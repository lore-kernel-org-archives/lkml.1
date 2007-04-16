Return-Path: <linux-kernel-owner+w=401wt.eu-S1031022AbXDPWZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031022AbXDPWZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031021AbXDPWZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:25:21 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:42504 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031002AbXDPWZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:25:20 -0400
Date: Mon, 16 Apr 2007 15:25:17 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: David Miller <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@SteelEye.com, ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
Message-ID: <20070416222517.GD14351@andrew-vasquezs-computer.local>
References: <20070416.123743.07452378.davem@davemloft.net> <20070416200857.GH10822@andrew-vasquezs-computer.local> <20070416211049.GC13590@andrew-vasquezs-computer.local> <20070416.150846.45744461.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416.150846.45744461.davem@davemloft.net>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 16 Apr 2007 22:25:04.0515 (UTC) FILETIME=[14B37530:01C78076]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, David Miller wrote:

> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Mon, 16 Apr 2007 14:10:49 -0700
> 
> > Ok, how about the following patch based on the one you posted which
> > adds the codes to retrieve the WWPN/WWNN from firmware on SPARC, and
> > also adds the module-parameter override I mentioned above.
> > 
> > Perhaps the module-parameter should be set to non-zero in the case of
> > SPARC, to take care of your system configurations?
> 
> I think it should default to non-zero always, in fact the option
> is completely pointless.
> 
> The guy who hits this had a system which worked previously, and you're
> explicitly breaking it.  That's wrong.

Sorry, 'it' didn't work...  'It' *never* did.

> How can you not see that this quality of implementation decision
> you're making stinks?

You're defending a position which itself left users with a false sense
of security and comfort.  This is a *real* problem from an enterprise
perspective where FC reigns.  Fine, I'll agree that wacking-users (and
I'll wager the outliers) with a 2x4 was a bit extreme, but I'd much
rather handle those users on a case-by-case basis, either by:

* If dealing with a PCI card, directing a user  to a support staff at
  QLogic to resolve the NVRAM issues.

* If it's some on-board ISP with no NVRAM, as was your SPARC case,
  then add *proper* codes to retrieve the data from some secondary
  persistent store.
