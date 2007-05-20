Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXETNiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXETNiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXETNhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:37:55 -0400
Received: from web52607.mail.re2.yahoo.com ([206.190.48.210]:35624 "HELO
	web52607.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755994AbXETNhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:37:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=VVnuLLdA/cK5ymVpsBvb2qtCR80rF6vA1VcdBl6HuKuR4T983JnHv0fHmQmtKIXOlT632J1qUnOR98oV43MhFpoaFKttYiAEv+26F9rnExPPz2WYx5BOr6I9wLdcUnRXDy1nu3PO/dKL1A5y/icqAopMMy4HjLEam5DGsrffXp4=;
X-YMail-OSG: 2EvdHIoVM1n23vfBfisug8lC.esiQzKql9RtT.oFQFT15QHM3VyoE.9ywR5jK0EruUtGCzPLc1DV8GweF8sllIN.AV6vdtREPSFf7XDQQgPtcpkTc8cRE6DBXPFegyhO3NJS9dsCuPtHa0Q-
Date: Sun, 20 May 2007 23:37:50 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0705200624q5f62a492o708a2e1c5e8d4c3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <814731.7111.qm@web52607.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/20/07, Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
> wrote:
> > --- Christoph Lameter <clameter@sgi.com> wrote:
> > > On Sun, 20 May 2007, Srihari Vijayaraghavan wrote:
> > >
> > > > Code: 0f ob eb fe 48 8b 1b 48 8b 0x 0f 18 08 48 81 fb 60 cb 51 80
> > > > RIP [...] slab_sysfs_init+0x49/0x98
> > > > RSP [...]
> > > > kernel panic - not syncing: Attempted to kill init!
> > >
> > > sysfs? If you build without CONFIG_SLUB_DEBUG then SLUB will not use
> > > sysfs. You can switch that off in the embedded section.
> >
> > Fair enough. Would you the section name it appears in 'menuconfig'?
> >
> > I looked under 'Kernel hacking' section (where the slab debugging appears
> if
> > slab is turned on as 'Debug slab memory allocation') & in the 'General
> setup'
> > section also. I unable to figure out how to disable slub debugging :-(.
> 
> SLUB_DEBUG is both "bool if EMBEDDED" and "depends on SLUB", which
> means just getting it to be visible in "menuconfig" is quite a challenge :-)
> 
> You first need to go into the choice where you pick the allocators ("Choose
> allocator --->" which is the last option in General Setup), and then pick
> SLUB as your allocator.
> 
> Then, from the General Setup again, turn on the "Configure standard
> kernel features (for small systems) --->" just above the previous option
> and then go into that menu. Now the option to disable SLUB_DEBUG
> (which is y by default) becomes visible, so just deselect it to disable it.

Thanks for that. I've just figured that out a few minutes ago :-). Was a
tricky one indeed. Then I captured and posted the current kernel bug report
while having slub just then.

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

