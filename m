Return-Path: <linux-kernel-owner+w=401wt.eu-S1752913AbZI2Qtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbZI2Qtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZI2Qtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:49:46 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:33987 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881AbZI2Qtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:49:45 -0400
Subject: Re: Paravirtualization on VMware's Platform [VMI].
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Arjan van de Ven <arjan@infradead.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090929100831.18ece319@infradead.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	 <20090919224430.GB9567@kroah.com>
	 <1253419185.3253.21.camel@ank32.eng.vmware.com>
	 <20090920074247.GA5733@elte.hu>
	 <1253647845.10565.20.camel@ank32.eng.vmware.com>
	 <4AB9CE66.1030504@redhat.com>
	 <1254185107.13456.32.camel@ank32.eng.vmware.com>
	 <20090929100831.18ece319@infradead.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 29 Sep 2009 09:49:49 -0700
Message-Id: <1254242989.7803.11.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-09-29 at 01:08 -0700, Arjan van de Ven wrote:
> > For now I have just added some text in the feature-removal file and
> > disabled VMI by default in the Kconfig, the reason that needs to be
> > done is because "Live Migration" of a VMI enabled VM to future
> > products which don't support VMI will not work, so its important that
> > newer distros keep this disabled, if they want seamless migration
> > that is.
> 
> btw the "default" in KConfig tends to be totally ignored by distro
> kernel maintainers... please don't assume that just because some default
> is set in KConfig it has ANY impact on what shows up in distributions.

So, are you saying that we should be doing something else along with
toggling it off in the Kconfig ? 
We have already informed most of the distro folks about this deprecation
so I think we should be okay there, but if there is something else that
should be done, do let me know.

Thanks,
Alok



