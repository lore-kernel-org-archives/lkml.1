Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZDEXKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZDEXKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZDEXK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:10:26 -0400
Received: from smtp5.Stanford.EDU ([171.67.219.85]:34026 "EHLO
	smtp5.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbZDEXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:10:24 -0400
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
In-Reply-To: <alpine.LFD.2.00.0904060001480.747@localhost.localdomain>
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
Content-Type: text/plain
Date: Sun, 05 Apr 2009 16:10:52 -0700
Message-Id: <1238973052.4995.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 00:02 +0200, Thomas Gleixner wrote:
> On Sun, 5 Apr 2009, Fernando Lopez-Lezcano wrote:
> > On Sun, 2009-04-05 at 15:53 +0200, Thomas Gleixner wrote:
> > > On Fri, 3 Apr 2009, Fernando Lopez-Lezcano wrote:
> > > > > > Just a heads up. I'm still having shutdown/suspend problems with this
> > > > > > release as before (I had not reported the suspend problem, I think -
> > > > > > machine hangs and has to be power cycled). Booting with "noreplace-smp"
> > > > > > fixes both. Is this something I could disable through configuration
> > > > > > options?
> > > > > 
> > > > > No. I have this shutdown/suspend thing on my todo list. 
> > > > 
> > > > Ah, ok. No problem. If it were not for this feature I'd probably release
> > > > a test version for Planet CCRMA. 
> > > 
> > > Happens this shutdown/suspend problem every time or is this sporadic ?
> > 
> > For me it is repeatable (on both a laptop and a desktop machine so it
> > does not appear to be very hardware specific). It might be of course an
> > interaction with the Fedora patches I use. 
> > 
> > In the category of "I wish I had a crystal ball" reports with no hard
> > data, I can confirm that my build of rt4 does hang. I was trying
> > 2.6.29.1-rt4 during a rehearsal for a concert yesterday[*] and after a
> > hard hang I reverted to the vanilla Fedora kernel (which is what I had
> > been using because of that problem - no clues left behind in logs). 
> 
> Hmm. Can you upload your full patch queue and the binary rpm so I can
> give it a test ride ?

Sure, no problem. I just did a release to planetcore-testing repo (with
a warning to the planetccrma list), you can find it here:

http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/i386/repoview/index.html
http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/x86_64/repoview/index.html

(the one I have tested and hangs is the i386 PAE version)
Source here:

http://ccrma.stanford.edu/planetccrma/mirror/fedora/linux/planetcore/testing/10/SRPMS/

(if you don't want to figure out the .src.rpm - I would not blame you -
I can give you a list of the patches that were actually applied - of the
ones that are included in the package)

-- Fernando


