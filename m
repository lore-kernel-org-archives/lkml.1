Return-Path: <linux-kernel-owner+w=401wt.eu-S1762097AbYESTJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbYESTJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbYESTJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:09:41 -0400
Received: from outbound-mail-154.bluehost.com ([67.222.39.34]:33485 "HELO
	outbound-mail-154.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754571AbYESTJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:09:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Date: Mon, 19 May 2008 12:09:19 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       len.brown@intel.com, Shaohua Li <shaohua.li@intel.com>
References: <20080515070546.6ea9c681@infradead.org> <200805162216.31463.rjw@sisk.pl> <20080516213721.GA13492@kroah.com>
In-Reply-To: <20080516213721.GA13492@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191209.20253.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2008 2:37 pm Greg KH wrote:
> On Fri, May 16, 2008 at 10:16:30PM +0200, Rafael J. Wysocki wrote:
> > On Friday, 16 of May 2008, Jesse Barnes wrote:
> > > On Thursday, May 15, 2008 12:51 pm Rafael J. Wysocki wrote:
> > > > Some quirks should be called with interrupt disabled, we can't
> > > > directly call them in .resume_early. Also the patch introduces
> > > > pci_fixup_resume_early and pci_fixup_suspend, which matches current
> > > > device core callbacks (.suspend/.resume_early).
> > > >
> > > > TBD: Somebody knows why we need quirk resume should double check if a
> > > > quirk should be called in resume or resume_early. I changed some per
> > > > my understanding, but can't make sure I fixed all.
> > > >
> > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > >
> > > I applied this one to linux-next, it should fix some of the problems
> > > people have been seeing at least...
> >
> > Well, that will collide with
> > pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
> > in the Greg's tree.
> >
> > Greg, perhaps it's better if you drop it and I'll send an updated version
> > to Jesse?  That will make his tree dependent on yours, but that will be
> > okay, won't it?
>
> That's up to Jesse.  I don't know if he can handle a depancy on an
> external tree.
>
> Jesse?

It would be easiest for me to just carry Rafael's patch, but that assumes 
you're ok with the changes.  Have you looked at it enough to feel good about 
it, Greg?

Thanks,
Jesse

