Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbXGTGCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbXGTGCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXGTGCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:02:35 -0400
Received: from ozlabs.org ([203.10.76.45]:42816 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbXGTGCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:02:34 -0400
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under
	arch-level Virtualization option
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <46A046F1.7040207@qumranet.com>
References: <1184905342.10380.263.camel@localhost.localdomain>
	 <46A046F1.7040207@qumranet.com>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 16:02:27 +1000
Message-Id: <1184911347.10380.274.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 08:24 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > Any objections?
> >
> > Rusty.
> > ===
> > Having KVM appear in the middle of "drivers" is kinda strange, and
> > having it alone under a menu called "virtualization" doubly so.
> >
> > 1) Move the "Virtualization" menu into the arch-specific i386 and
> >    x86-64 Kconfig.
> >   
> 
> Virtualization is hardly x86 specific.  How about moving it to
> top-level, and having individual items disable themselves on archs they
> don't apply to?
> 
> Otherwise we end up with $NARCH copies of that Kconfig, each slightly
> different.  The top-level entry can be made to depend on the archs that
> actually have some virt capability, so as not to show empty an menu.

I dislike the duplication, too, but 

1) it's a CPU capability, and that's where it belongs in the menu.
2) And as you can see from the difference between the x86_64 and i386
help text, there are real platform differences (and not mentioning
what's under the menu would be kinda cheating).
3) Virtualization doesn't even make sense as an option for some
platforms where it's always on.

Cheers,
Rusty.

