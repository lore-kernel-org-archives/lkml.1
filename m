Return-Path: <linux-kernel-owner+w=401wt.eu-S1161264AbXCHX6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264AbXCHX6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161282AbXCHX6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:58:37 -0500
Received: from www.osadl.org ([213.239.205.134]:60329 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161264AbXCHX6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:58:36 -0500
Subject: Re: hardwired VMI crap
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zach@vmware.com>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
In-Reply-To: <45F09EAE.6090908@goop.org>
References: <45EF175D.6030609@vmware.com>
	 <1173302503.24738.795.camel@localhost.localdomain>
	 <45EF372E.7030600@goop.org>
	 <1173308717.24738.898.camel@localhost.localdomain>
	 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>
	 <45EFE010.7080108@vmware.com>
	 <1173352154.24738.1023.camel@localhost.localdomain>
	 <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org>
	 <20070308213458.GA24634@elte.hu>  <45F09EAE.6090908@goop.org>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 01:04:50 +0100
Message-Id: <1173398690.24738.1108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 15:39 -0800, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >  - /One/ _intelligent_ higher-level virtualization API/ABI. Xen's API is 
> >    quite advanced on this front.
> 
> At last!  Some love!
> 
> The Xen approach has always been to prefer high-level interfaces over
> lower-level ones, so that guests can meaningfully participate in their
> own virtualization.  There are some necessarily low-level things, but
> conceptually simple things like "create a new vcpu" should have simple
> interfaces.  There's no point in going to the effort of emulating a
> whole pile of real hardware if Xen can present an interface which is a
> close match to an existing high-level interface within the operating system.

Once you are there, you are near the point where you created a virtual
architecture, which could run on any real architecture which gets
supported by a hypervisor backend.

I'd love that :)

I know it is tricky to combine this with the upcoming hardware
virtualization support. But it's at least a worthwhile thought
experiment.

	tglx


