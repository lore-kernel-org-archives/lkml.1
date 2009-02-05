Return-Path: <linux-kernel-owner+w=401wt.eu-S1761100AbZBEAlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761100AbZBEAlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZBEAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:41:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:44091 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZBEAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:41:28 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
	 <1233783502.4612.7.camel@pasglop>
	 <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 11:40:10 +1100
Message-Id: <1233794410.4612.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 13:56 -0800, Linus Torvalds wrote:
> 
> On Thu, 5 Feb 2009, Benjamin Herrenschmidt wrote:
> > 
> > How so ? I've had such backtraces with no other info in my log...
> 
> _with_ that patch?
> 
> It very much replaces a warning with no further info with
> 
> +                       WARN_ONCE(pci_dev->current_state != prev,
> +                               "PCI PM: Device state not saved by %pF\n",
> +                               drv->suspend);
> 
> And notice the "%pF" and the 'drv->suspend': it should tell you exactly 
> which suspend routine it was that messed up.

Yup, missed that change in the patch. In fact, I even missed the
existence of a WARN_ONCE that takes those text arguments... baaaah. I
suppose I should try to read more of lkml :-)

Cheers,
Ben.


