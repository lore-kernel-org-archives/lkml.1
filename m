Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZDGROd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZDGROd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZDGROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:14:22 -0400
Received: from smtp5.Stanford.EDU ([171.67.219.85]:41022 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZDGROU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:14:20 -0400
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
In-Reply-To: <1239123123.12637.9.camel@localhost.localdomain>
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
	 <1239123123.12637.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 10:14:53 -0700
Message-Id: <1239124493.12637.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 09:52 -0700, Fernando Lopez-Lezcano wrote:
> On Mon, 2009-04-06 at 21:54 +0200, Thomas Gleixner wrote:
> > Fernando,
> > 
> > On Sun, 5 Apr 2009, Fernando Lopez-Lezcano wrote:
> > > > Hmm. Can you upload your full patch queue and the binary rpm so I can
> > > > give it a test ride ?
> > > 
> > > Sure, no problem. I just did a release to planetcore-testing repo (with
> > > a warning to the planetccrma list)
> > 
> > No problem. I know how to distangle those beasts.
> > 
> > Still I have no reproducer yet. One of my 32bit test machines survived
> > a 200 cycle test w/o showing it.
> 
> Arghh, I don't know what it could be then. You mean 200 power cycles??
> Wow... it only takes one here. Thanks for testing. 
> 
> > Is there anything special what you run, load ... ?
> 
> Not that I can think of right now. This happens on 32 bit installs on
> both Fedora 9 and Fedora 10. Nothing special installed, of course I have
> the Planet CCRMA packages but they don't involve additional kernel
> modules or anything that (I think) deals with startup or shutdown. 

Maybe I am a special case, somehow:

-------- Forwarded Message --------
From: Timo Sivula
To: planetccrma@ccrma.Stanford.EDU
Subject: Re: [PlanetCCRMA] for brave users only, kernel 2.6.29.1-rt4 for
fc10
Date: Tue, 07 Apr 2009 12:46:41 +0300

ma, 2009-04-06 kello 12:00 -0700, planetccrma-request@ccrma.Stanford.EDU
kirjoitti:

> I just pushed a new build of 2.6.29.1-rt4 (Thomas Gleixner, one of the
> gurus working on the rt patches would like to give it a whirl and the
> easiest way is to put it in planetcore-testing) even though it is not
> "stable" for me. 

Starts and closes fine here with my system. Also has not made my mouse
slow, yet. However, neither ndiswrapper 1.53 nor 1.54 does compile with
this kernel.



