Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZI2JDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZI2JDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 05:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZI2JDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 05:03:23 -0400
Received: from sous-sol.org ([216.99.217.87]:52045 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751052AbZI2JDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 05:03:22 -0400
Date: Tue, 29 Sep 2009 02:01:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Alok Kataria <akataria@vmware.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20090929090130.GD3958@sequoia.sous-sol.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com> <20090920074247.GA5733@elte.hu> <1253647845.10565.20.camel@ank32.eng.vmware.com> <4AB9CE66.1030504@redhat.com> <1254185107.13456.32.camel@ank32.eng.vmware.com> <4AC17018.4040600@zytor.com> <1254193238.13456.48.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254193238.13456.48.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alok Kataria (akataria@vmware.com) wrote:
> 
> On Mon, 2009-09-28 at 19:25 -0700, H. Peter Anvin wrote:
> > On 09/28/2009 05:45 PM, Alok Kataria wrote:
> > > +	bool "VMI Guest support [will be deprecated soon]"
> > > +	default n
> > 
> > This is incorrect use of the word "deprecated"... it's *already*
> > deprecated (a word which pretty much means the opposite of "recommended".)
> > 
> > As far as "default n" is concerned... this is usually not necessary; "n"
> > is the default unless anything else is specified.
> 
> How about this ?  Thanks.

Looks good to me (missing Signed-off-by).  I think it's also useful
to generate some runtime noise saying it's a deprecated option.

Even something as simple as:

-	pv_info.name = "vmi"
+	pv_info.name = "vmi [deprecated]";

