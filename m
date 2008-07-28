Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYG1UwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYG1UwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbYG1UwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:52:15 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:1832 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbYG1UwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:52:14 -0400
X-Trace: 50442775/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/81.1.72.79
X-SBRS: None
X-RemoteIP: 81.1.72.79
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAJHOjUhRAUhP/2dsb2JhbACBW65q
X-IronPort-AV: E=Sophos;i="4.31,267,1215385200"; 
   d="scan'208";a="50442775"
Subject: Re: drivers/sh/maple/maple.c compile error
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080728204438.GC20019@linux-sh.org>
References: <20080728202012.GD7713@cs181140183.pp.htv.fi>
	 <20080728204438.GC20019@linux-sh.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 21:51:48 +0100
Message-Id: <1217278308.6875.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 05:44 +0900, Paul Mundt wrote:
> On Mon, Jul 28, 2008 at 11:20:12PM +0300, Adrian Bunk wrote:
> > Commit 306cfd630a4d121cf4e08b894d8b4c4cf106e57e
> > (maple: tidy maple_driver code by removing redundant connect/disconnect)
> > causes the following compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      drivers/sh/maple/maple.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'attach_matching_maple_driver':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:259: error: 'struct maple_driver' has no member named 'connect'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c: In function 'maple_detach_driver':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:272: error: 'struct maple_driver' has no member named 'disconnect'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/sh/maple/maple.c:273: error: 'struct maple_driver' has no member named 'disconnect'
> > make[4]: *** [drivers/sh/maple/maple.o] Error 1
> > 
> > <--  snip  -->
> > 
> Adrian was supposed to send follow-up patches for this, which never
> happened. I thought I had dropped this already, but in this case I'll
> just revert it.

Actually I wasn't asked about this, but to submit a fix/replacement for
a patch that didn't apply.

I will submit a patch for the whole thing then - as I cannot actually
match the commit Adrian has quoted to anything.

I think the problem is that I am trying to get a change in the bus and
in the drivers (which have different maintainers) to go in together and
that has never quite worked. The code runs fine on my box and has done
for months now.

Adrian

