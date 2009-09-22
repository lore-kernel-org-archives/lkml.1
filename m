Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZIVHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZIVHWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbZIVHWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:22:34 -0400
Received: from ozlabs.org ([203.10.76.45]:33401 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbZIVHWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:22:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Date: Tue, 22 Sep 2009 16:52:32 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com> <20090920095239.456ad6f2@infradead.org> <4AB5EF25.9070502@redhat.com>
In-Reply-To: <4AB5EF25.9070502@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221652.35446.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 06:30:21 pm Avi Kivity wrote:
> On 09/20/2009 10:52 AM, Arjan van de Ven wrote:
> > On Sun, 20 Sep 2009 09:42:47 +0200
> > Ingo Molnar<mingo@elte.hu>  wrote:
> >
> >    
> >> If we were able to rip out all (or most) of paravirt from arch/x86 it
> >> would be tempting for other technical reasons - but the patch above
> >> is well localized.
> >>      
> > interesting question is if this would allow us to remove a few of the
> > paravirt hooks....
> >    
> 
> kvm will be removing the pvmmu support soon; and Xen is talking about 
> running paravirtualized guests in a vmx/svm container where they don't 
> need most of the hooks.

When they're all gone, even I don't think lguest is sufficient excuse
to keep CONFIG_PARAVIRT.  Oh well.  But that will probably be a while.

Cheers,
Rusty.
