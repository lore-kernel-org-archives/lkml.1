Return-Path: <linux-kernel-owner+w=401wt.eu-S932357AbYFFUxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbYFFUxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYFFUxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:53:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47826 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYFFUxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:53:10 -0400
Date: Fri, 6 Jun 2008 13:42:27 -0700
From: Greg KH <greg@kroah.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Gene Heskett <gene.heskett@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.25.1, stray noise in dmesg
Message-ID: <20080606204227.GC11209@kroah.com>
References: <200805021126.15225.gene.heskett@gmail.com> <200806052050.34537.elendil@planet.nl> <20080605193815.GA32072@kroah.com> <200806061455.57361.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806061455.57361.elendil@planet.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 02:55:55PM +0200, Frans Pop wrote:
> On Thursday 05 June 2008, Greg KH wrote:
> > On Thu, Jun 05, 2008 at 08:50:33PM +0200, Frans Pop wrote:
> > > On Friday 02 May 2008, Frans Pop wrote:
> > > > I'm seeing these too (hub 5-0):
> > > > hub 5-0:1.0: USB hub found
> > > > hub 5-0:1.0: unable to enumerate USB device on port 5
> > > > hub 5-0:1.0: unable to enumerate USB device on port 7
> > >
> > > Note that in my case this is not with an external hub or anything,
> > > but just the internal USB ports of the system.
> > >
> > > One thing with this message is that because of its "error" status, it
> > > also shows when the system is booted with the "quiet" option. Could
> > > it be an option to apply the following patch so that at least that is
> > > avoided?
> >
> > I agree, I'll change the message to be this, thanks for the patch.
> 
> I'm not sure that it is needed anymore. Looks like for me the messages 
> have disappeared with -rc5, probably due to 3a31155cfff0935e (Alan Stern,
> "USB: EHCI: suppress unwanted error messages").
> So it wasn't broken hardware after all :-)
> 
> If that solves all or most cases the error was being hit, lowering its 
> severity is probably not needed.

Ah, nevermind then, I'll not worry about this :)

thanks,

greg k-h
