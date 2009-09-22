Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbZIVVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbZIVVyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZIVVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:54:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53054 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbZIVVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:54:32 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4AB9414C.6060805@zytor.com>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
	 <1253419185.3253.21.camel@ank32.eng.vmware.com>
	 <20090920074247.GA5733@elte.hu>
	 <1253647845.10565.20.camel@ank32.eng.vmware.com>
	 <4AB9414C.6060805@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 22 Sep 2009 14:54:36 -0700
Message-Id: <1253656476.10565.28.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-09-22 at 14:27 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> > Hi Ingo,
> > 
> > On Sun, 2009-09-20 at 00:42 -0700, Ingo Molnar wrote:
> > 
> >> The thing is, the overwhelming majority of vmware users dont benefit 
> >> from hardware features like nested page tables yet. So this needs to be 
> >> done _way_ more carefully, with a proper sunset period of a couple of 
> >> kernel cycles.
> > 
> > I am fine with that too. Below is a patch which adds notes in
> > feature-removal-schedule.txt, I have marked it for removal from 2.6.34.
> > Please consider this patch for 2.6.32.
> > 
> 
> This seems way, way too early still.

What do you suggest would be the right time ? 

Please note that the next major release of VMware's product will not
have this supported. Also that, most of our customers will actually be
running some distro's enterprise release, rather than running the
cutting edge kernel. So IMO there is still a window of around 1-1.5
years, until a customer actually sees a kernel which has dropped VMI
support.

Thanks,
Alok

