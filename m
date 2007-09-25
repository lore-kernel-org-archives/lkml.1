Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXIYJHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXIYJHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXIYJHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:07:01 -0400
Received: from www.osadl.org ([213.239.205.134]:48169 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbXIYJHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:07:00 -0400
Subject: Re: Why do so many machines need "noapic"?
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Prakash Punnoor <prakash@punnoor.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46E96792.5000607@redhat.com>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de>
	 <46E1A7B5.6000104@redhat.com> <200709080717.58271.prakash@punnoor.de>
	 <46E59716.6020404@redhat.com> <20070910194421.GA1819@one.firstfloor.org>
	 <46E96792.5000607@redhat.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 11:06:55 +0200
Message-Id: <1190711215.4035.283.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck,

On Thu, 2007-09-13 at 12:38 -0400, Chuck Ebbert wrote:
> On 09/10/2007 03:44 PM, Andi Kleen wrote:
> >> Yes, it has an hpet. And I tried every combination of options I could
> >> think of.
> > 
> >> But, even stranger, x86_64 works (only i386 fails.)
> > 
> > x86-64 has quite different time code (at least until the dyntick patches
> > currently in mm) 
> > 
> > Obvious thing would be to diff the boot messages and see if anything
> > jumps out (e.g. in interrupt routing).  
> > 
> > Or check with mm and if x86-64 is broken there too then it's likely
> > the new time code.
> 
> I reported too soon that x86_64 works. It does not work, it just takes
> a bit longer before it freezes. There are message threads all over the
> place discussing this problem with the HP Pavilion tx 1000, and it seems
> the best workaround is to use the "nolapic" option instead of "noapic".
> Using that, it is totally stable _and_ there are no spurious interrupts
> that would otherwise break USB. Interrupt setup is a bit strange, though:

can you please send me 32 and 64 bit boot logs of mainline and fedora
kernels ?

	tglx


