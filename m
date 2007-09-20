Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXITQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXITQop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXITQoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:44:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXITQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:44:37 -0400
Date: Thu, 20 Sep 2007 22:17:27 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Charles N Wyble <charles@thewybles.com>
cc: Andi Kleen <ak@suse.de>, virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
In-Reply-To: <46F29B4B.2070200@thewybles.com>
Message-ID: <alpine.LFD.0.999.0709202207360.19354@enigma.security.iitk.ac.in>
References: <1189747054.7262.34.camel@localhost.localdomain>
 <200709181257.41530.ak@suse.de> <46F02F50.5000001@thewybles.com>
 <200709182220.27311.ak@suse.de> <46F034A8.2070801@thewybles.com>
 <alpine.LFD.0.999.0709202110150.18597@enigma.security.iitk.ac.in>
 <46F29B4B.2070200@thewybles.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Charles N Wyble wrote:
> 
> Satyam Sharma wrote:
> > 
> > On Tue, 18 Sep 2007, Charles N Wyble wrote:
> >> Andi Kleen wrote:
> >>> Besides it's bad taste and taste is very important.
> >> Well it's bad taste for you (one person).
> > 
> > FWIW, my opinion is the same as Andi's here. Please, let's avoid this
> > disease -- unless *absolutely* required, stuff shouldn't be "default y".
> 
> I am curious why you think it shouldn't be default why? Bad taste? Can
> you provide data about how it will harm things?

Clear CONFIG_PARAVIRT from your .config and try "make oldconfig", and find
out for yourself :-)

You'll end up having to answer questions for all other config options
below it, that you never cared about, that you didn't know even existed.
You'd obviously (I would, at least) feel annoyed by it all ... this is
almost a regression :-)

And for those who automate the oldconfig process using "yes", well, this
"default y" *will* end up introducing a kernel text size regression --
all those config options they never had earlier, suddenly got enabled.

Besides, like Andi said, selecting or enabling CONFIG_PARAVIRT is quite
pointless in the first place -- it's just a menuconfig symbol, not a
"real" kconfig symbol that _actually_ controls code in the Makefiles.


Satyam
