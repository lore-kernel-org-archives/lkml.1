Return-Path: <linux-kernel-owner+w=401wt.eu-S1161361AbXCIAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161361AbXCIAoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161362AbXCIAoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:44:23 -0500
Received: from gw.goop.org ([64.81.55.164]:46477 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161361AbXCIAoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:44:22 -0500
Message-ID: <45F0ADE1.6060303@goop.org>
Date: Thu, 08 Mar 2007 16:44:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
References: <45EF175D.6030609@vmware.com>	 <1173302503.24738.795.camel@localhost.localdomain>	 <45EF372E.7030600@goop.org>	 <1173308717.24738.898.camel@localhost.localdomain>	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>	 <45EFE010.7080108@vmware.com>	 <1173352154.24738.1023.camel@localhost.localdomain>	 <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org>	 <20070308213458.GA24634@elte.hu>  <45F09EAE.6090908@goop.org> <1173398690.24738.1108.camel@localhost.localdomain>
In-Reply-To: <1173398690.24738.1108.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Once you are there, you are near the point where you created a virtual
> architecture, which could run on any real architecture which gets
> supported by a hypervisor backend.
>
> I'd love that :)
>   

Sure.  But not even hypervisors.  Once we sort out pv_ops's SMP support,
it will be this >< close to covering everything in the subarch
interface.  So we can drop all that goo in favour of paravirt_ops, and
make a single kernel that will boot on everything from voyager to
numa-q!  How's that for world peace?

> I know it is tricky to combine this with the upcoming hardware
> virtualization support. But it's at least a worthwhile thought
> experiment.
>   

Well, in many ways that's a step backwards.  The upside is that its
easier to get away with simply emulating the some particular piece
hardware, but it does lose a lot of opportunities for interesting
flexibility and optimisations.

But I anticipate we'll get a xen-hvm pv_ops backend, for running under
Xen with a virtualizing cpu.  It will probably look a lot like kvm's
pv_ops backend.

    J


