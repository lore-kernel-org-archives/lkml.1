Return-Path: <linux-kernel-owner+w=401wt.eu-S965769AbXD1LSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965769AbXD1LSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbXD1LSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:18:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbXD1LSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:18:39 -0400
Date: Sat, 28 Apr 2007 13:18:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070428111835.GA4471@one.firstfloor.org>
References: <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070427221803.2a117c23.akpm@linux-foundation.org> <p73tzv022qw.fsf@bingen.suse.de> <20070428030213.4787031f.akpm@linux-foundation.org> <20070428111504.24641d03@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428111504.24641d03@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 11:15:04AM +0100, Alan Cox wrote:
> > > The warning is bogus imho. How do you write recovery code for internal
> > > broken code logic? 
> > 
> > Yes, it is marginal.  But people do very often reach for BUG_ON() where
> > they could have at least partly recovered in some fashion - enough for the
> > info to hit the logs so we have a better chance of fixing it.
> 
> At least one way to handle BUG_ON() type situations more cleanly (for
> some anyway) is to fake a hot-unplug/plug event. Thats something that

That would have a high risk of deadlock on some lost lock.

-Andi
