Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYEPUQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYEPUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYEPUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:16:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48479 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYEPUQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:16:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Date: Fri, 16 May 2008 22:16:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       Shaohua Li <shaohua.li@intel.com>
References: <20080515070546.6ea9c681@infradead.org> <200805152151.31936.rjw@sisk.pl> <200805161051.49919.jbarnes@virtuousgeek.org>
In-Reply-To: <200805161051.49919.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805162216.31463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 of May 2008, Jesse Barnes wrote:
> On Thursday, May 15, 2008 12:51 pm Rafael J. Wysocki wrote:
> > Some quirks should be called with interrupt disabled, we can't directly
> > call them in .resume_early. Also the patch introduces
> > pci_fixup_resume_early and pci_fixup_suspend, which matches current
> > device core callbacks (.suspend/.resume_early).
> >
> > TBD: Somebody knows why we need quirk resume should double check if a
> > quirk should be called in resume or resume_early. I changed some per my
> > understanding, but can't make sure I fixed all.
> >
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> I applied this one to linux-next, it should fix some of the problems people 
> have been seeing at least...

Well, that will collide with
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type.patch
in the Greg's tree.

Greg, perhaps it's better if you drop it and I'll send an updated version to
Jesse?  That will make his tree dependent on yours, but that will be okay,
won't it?

Thanks,
Rafael
