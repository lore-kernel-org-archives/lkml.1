Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZF3Kha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZF3Kha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZF3KhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:37:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:50243 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZF3KhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:37:19 -0400
Subject: Re: Can't boot 2.6.30 powerpc kernel under qemu.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Landley <rob@landley.net>
Cc: Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <200906291834.07902.rob@landley.net>
References: <200906281033.09842.jk@ozlabs.org>
	 <200906291834.07902.rob@landley.net>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 20:24:48 +1000
Message-Id: <1246357488.31413.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 18:34 -0500, Rob Landley wrote:
> 
> Which suggested that the problem was the new
> CONFIG_PPC_OF_BOOT_TRAMPOLINE 
> symbol wasn't set, and once I switched that on it started working
> again.

Ah, I might have forgot to set it to default y...

> > linuxppc-dev@lists.ozlabs.org is the one you want for this:
> >
> >  https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
> Cool!  Is there a reason it's hidden?  (Or at least not listed in
> either 
> vger.kernel.org's list info page or in the "Maling lists" page linked
> from 
> ozlabs.org's top level web page.)  Just curious, I couldn't find it
> when I 
> looked in the obvious (to me) places.

It's a glitch of the transition from ozlabs.org to lists.ozlabs.org for
lists... they haven't all moved over yet so it's still a bit messy.

> Rob
> 
> P.S.  Yes I tried google: top hit for "linux powerpc list" is
> penguinppc.org, 
> which links to mailing lists on the right which is the ozlabs.org page
> that 
> doesn't list linuxppc-dev.  In fact the entire first page of google
> hits for 
> that search doesn't give a hint of the existence of that list,
> although some 
> of the later ones might if I clicked through more of them...

I'll check with Stephen if we can get the ozlabs.org page a link to the
new lists.ozlabs.org or something like that...

Cheers,
Ben.


