Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYHFOXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYHFOXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYHFOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:20:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35204 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYHFOUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:20:46 -0400
Date: Wed, 6 Aug 2008 09:20:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Peter Dolding <oiaohm@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Rik van Riel <riel@redhat.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080806142025.GB10274@us.ibm.com>
References: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805205129.37d873f0@bree.surriel.com> <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com> <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com> <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com> <20080806064944.441305eb@infradead.org> <1218030956.27684.232.camel@localhost.localdomain> <e7d8f83e0808060711o43f1dc9frc859c2583e51b195@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d8f83e0808060711o43f1dc9frc859c2583e51b195@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Peter Dolding (oiaohm@gmail.com):
> On Wed, Aug 6, 2008 at 11:55 PM, Eric Paris <eparis@redhat.com> wrote:
> > On Wed, 2008-08-06 at 06:49 -0700, Arjan van de Ven wrote:
> >> On Wed, 6 Aug 2008 09:11:14 -0400
> >> > There was probably an implicit assumption on everyone's part,
> >> > including Red Hat's, that what ought to be done was to replace the
> >> > existing syscall-based event trapping with some other interface that
> >> > more or less does the same thing in a cleaner way -- NOT to have all
> >> > of the AV and other product vendors go out and completely rethink
> >> > their models.  And that's not because we inherently object to
> >> > rethinking.  It's really an issue of what kind of time frame we have
> >> > before a new OS goes out that completely breaks our products.
> >>
> >> not writing to the syscall table hasn't been possible/allowed for..
> >> about 5 years now. (yes I know there were still bad hacks possible
> >> until 2 years ago). So I'm sorry, but the timeline argument doesn't
> >> hold, you've had 5+ years of warning.
> >>
> >> All existing RHEL products already don't allow this (I know it for the
> >> earlier ones since I was part of the design team)...  unless your
> >> software acts entirely like a rootkit (but even then)
> >
> > Other options involved overwriting LSM function pointers.  I was told
> > that recently moving SELinux to be statically compiled in apparently
> > messed them up on that method, at least for RH products.  The other
> > method I've heard is hunting down all of the filesystem_operations
> > structs and overwriting those functions.  I was also told that until
> > recently pages marked RO could just be marked RW and then remarked RO,
> > although it was recently fixed to RO pages stayed RO.  So yeah, I'd have
> > to call them all ugly rootkit like hacks.
> >
> > they just keep finding uglier and uglier ways to infiltrate the kernel
> > which is why I was ask to try to help get a clean solution.
> >
> Simplely they are following the windows way of doing things.  Rootkit
> the OS no one will stop us.  Sorry that RootKitting is not going to
> work here long term because we will fix Root Kit weaknesses.  TPM from
> IBM will make it even harder.  Nice bits of that are in 2.6.27.
> 
> Allowing LSM stacking solves nothing.   IBM's developers credentials

Seriously, it's David Howells at Redhat who's doing that.  In your last
email i figured it was a typo, but credit where it's due :)

-serge
