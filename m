Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZI2IMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZI2IMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZI2IMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:12:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:43754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZI2IMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:12:03 -0400
Date: Tue, 29 Sep 2009 10:08:31 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: akataria@vmware.com
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
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090929100831.18ece319@infradead.org>
In-Reply-To: <1254185107.13456.32.camel@ank32.eng.vmware.com>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	<20090919224430.GB9567@kroah.com>
	<1253419185.3253.21.camel@ank32.eng.vmware.com>
	<20090920074247.GA5733@elte.hu>
	<1253647845.10565.20.camel@ank32.eng.vmware.com>
	<4AB9CE66.1030504@redhat.com>
	<1254185107.13456.32.camel@ank32.eng.vmware.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For now I have just added some text in the feature-removal file and
> disabled VMI by default in the Kconfig, the reason that needs to be
> done is because "Live Migration" of a VMI enabled VM to future
> products which don't support VMI will not work, so its important that
> newer distros keep this disabled, if they want seamless migration
> that is.

btw the "default" in KConfig tends to be totally ignored by distro
kernel maintainers... please don't assume that just because some default
is set in KConfig it has ANY impact on what shows up in distributions.
