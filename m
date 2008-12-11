Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbYLKXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbYLKXmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYLKXlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:41:31 -0500
Received: from kroah.org ([198.145.64.141]:36976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757320AbYLKXla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:41:30 -0500
Date: Thu, 11 Dec 2008 15:40:41 -0800
From: Greg KH <greg@kroah.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@wizards.de>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Nasty regression from .27.7 to .27.8: idle samba goes
	crazy
Message-ID: <20081211234041.GA1119@kroah.com>
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com> <493FFE5E.2000404@colorfullife.com> <49419A14.50402@wizards.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49419A14.50402@wizards.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:54:12PM +0100, Holger Hoffstätte wrote:
> 
> Dear all -
> 
> Thanks for your efforts.
> 
> Manfred Spraul wrote:
> > Chuck Ebbert wrote:
> >> On Mon, 8 Dec 2008 23:22:46 +0100
> >> Jan Rekorajski <baggins@sith.mimuw.edu.pl> wrote:
> >>
> >>  
> >>> On Mon, 08 Dec 2008, Stefan Richter wrote:
> >>>
> >>>    
> >>>>>>> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
> >>>>>>>            
> >>>>>>>> The system is a generic old single-core P4 box with a single
> >>>>>>>> SATA drive,
> >>>>>>>> Gentoo userland and Samba is 3.0.33 (in async mode). The kernel
> >>>>>>>> has no
> >>>>>>>> patches or binary drivers.
> >>>>>>>>               
> >>>> Holger, it may be unrelated to the issue, but to be sure:  Which
> >>>> network
> >>>> card driver do you use?
> >>>>       
> >>> I think you can safely rule out NIC, I'm also seeing this behaviour on a
> >>> brand new server with imap hanging in some busy-loop.
> >>> Network card in my case:
> >>> Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> >>>
> >>> What I observer was one CPU doing 100% system work, and the number of
> >>> timer interrupts went from 1k per second to 4k (for the whole system).
> >>>
> > Could you try the attached patch?
> > It should fix the bug.
> 
> I just built 2.6.27.9-rc1 and disconnected the Windowz box several times.
> For now smbd does not seem to go into a death spin any more, even though
> as far as I can tell .9-rc1 does not contain Manfred'd latest patch. Not
> sure what that means, if anything.

.9-rc1 does contain a cifs patch, so perhaps that resolved the issue for
you.

thanks,

greg k-h
