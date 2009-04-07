Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbZDGQvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbZDGQvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZDGQvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:51:35 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:56601 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZDGQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:51:34 -0400
Subject: Re: [Announce] 2.6.29.1-rt4
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0904062151020.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <1238799852.3871.6.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904040628310.12916@localhost.localdomain>
	 <1238828273.15225.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904051552320.747@localhost.localdomain>
	 <1238968196.4995.15.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904060001480.747@localhost.localdomain>
	 <1238973052.4995.29.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0904062151020.21577@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 09:52:03 -0700
Message-Id: <1239123123.12637.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 21:54 +0200, Thomas Gleixner wrote:
> Fernando,
> 
> On Sun, 5 Apr 2009, Fernando Lopez-Lezcano wrote:
> > > Hmm. Can you upload your full patch queue and the binary rpm so I can
> > > give it a test ride ?
> > 
> > Sure, no problem. I just did a release to planetcore-testing repo (with
> > a warning to the planetccrma list), you can find it here:
> > 
> > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/i386/repoview/index.html
> > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/x86_64/repoview/index.html
> > 
> > (the one I have tested and hangs is the i386 PAE version)
> > Source here:
> > 
> > http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/SRPMS/
> > 
> > (if you don't want to figure out the .src.rpm - I would not blame you -
> > I can give you a list of the patches that were actually applied - of the
> > ones that are included in the package)
> 
> No problem. I know how to distangle those beasts.
> 
> Still I have no reproducer yet. One of my 32bit test machines survived
> a 200 cycle test w/o showing it.

Arghh, I don't know what it could be then. You mean 200 power cycles??
Wow... it only takes one here. Thanks for testing. 

> Is there anything special what you run, load ... ?

Not that I can think of right now. This happens on 32 bit installs on
both Fedora 9 and Fedora 10. Nothing special installed, of course I have
the Planet CCRMA packages but they don't involve additional kernel
modules or anything that (I think) deals with startup or shutdown. 

> Looks like I need to add a 32bit install to my T61 in the hope to
> reproduce.

Sorry for the inconvenience. Additional installs, argh (BTW, I won't be
reading email for at least a week, of to LAC2009 tomorrow with a week of
R&R before - please keep cc'ing me on rt stuff). 

Thanks!!!
-- Fernando


