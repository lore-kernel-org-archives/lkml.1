Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXLOEJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXLOEJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbXLOEJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:09:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58963 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbXLOEJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:09:14 -0500
Date: Fri, 14 Dec 2007 20:12:00 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.23.10
Message-ID: <20071215041200.GA3987@kroah.com>
References: <20071214194952.GA15765@kroah.com> <47633028.20503@redhat.com> <200712150315.22568.rjw@sisk.pl> <200712150355.41763.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712150355.41763.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 03:55:40AM +0100, Rafael J. Wysocki wrote:
> On Saturday, 15 of December 2007, Rafael J. Wysocki wrote:
> > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > > On 12/14/2007 08:52 PM, Rafael J. Wysocki wrote:
> > > > On Saturday, 15 of December 2007, Chuck Ebbert wrote:
> > > >> On 12/14/2007 02:49 PM, Greg Kroah-Hartman wrote:
> > > >>>       Freezer: Fix APM emulation breakage
> > > >> drivers/char/apm-emulation.c: In function 'apm_ioctl':
> > > >> drivers/char/apm-emulation.c:370: error: implicit declaration of function 'wait_event_freezable'
> > > >> make[2]: *** [drivers/char/apm-emulation.o] Error 1
> > > >> make[1]: *** [drivers/char] Error 2
> > > > 
> > > > This is my fault, sorry.
> > > > 
> > > > I though the 2.6.24-rc fix would be suitable for 2.6.23.x, but that's not the
> > > > case.
> > > > 
> > > > Greg, please revert the "Freezer: Fix APM emulation breakage" patch, I'll
> > > > prepare a separate fix suitable for -stable.
> > > > 
> > > 
> > > It works if you add the changes to freezer.h made in commit
> > > e42837bcd35b75bb59ae5d3e62f87be1aeeb05c3
> > 
> > Yes, exactly, but a new patch is needed anyway.
> > 
> > Hmm, perhaps it's better to add a new patch on top of "Freezer: Fix APM
> > emulation breakage"?  Would that be preferred?
> 
> For convenience, below is the patch that should fix the breakage when applied
> on top of the "Freezer: Fix APM emulation breakage" patch.

Can you send me a whole new patch that works properly for the next
2.6.23-stable release?

thanks,

greg k-h
