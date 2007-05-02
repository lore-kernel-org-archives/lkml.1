Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXEBHrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXEBHrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030847AbXEBHrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:47:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33400 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030351AbXEBHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:47:51 -0400
X-Originating-Ip: 74.109.98.66
Date: Wed, 2 May 2007 03:47:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Rientjes <rientjes@google.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705020015470.22717@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705020344480.6259@localhost.localdomain>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <20070502051723.GB5843@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0705020257520.5859@localhost.localdomain>
 <Pine.LNX.4.64.0705020015470.22717@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, David Rientjes wrote:

> On Wed, 2 May 2007, Robert P. J. Day wrote:
>
> >   not only that, but there are numerous files that *already* use
> > "__unused":
> >
> > $ grep -rw __unused *
> > ... snip lots of output here ...
> >
> > as well as a few files that can now have their definition of that
> > removed:
> >
> > $ grep -r "define __unused" *
> > drivers/net/defxx.c:#define __unused __attribute__ ((unused))
> > drivers/net/declance.c:#define __unused __attribute__ ((unused))
> > drivers/misc/thinkpad_acpi.c:#define __unused __attribute__ ((unused))
> >
> >   i think "__unused" is the clear choice here.
> >
>
> No, it's not the clear choice.  This would apply to both functions
> and variables so the suppress a compiler warning for a variable
> whose use depends on preprocessor macros, I would have to use
> __unused even though it may be used.
>
> Hence, I recommend __maybe_unused.

sorry, i worded that badly.  i suggested that "__unused" was the clear
choice only because it already had significant historical precedent
and people on this list are notorious for not liking major, disruptive
changes.

if no one objects to changing the existing occurrences, then no
problem.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
