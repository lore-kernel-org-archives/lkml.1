Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0CFRHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 12:07:39 -0500
Received: from kroah.org ([198.145.64.141]:53050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab0CFRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 12:07:26 -0500
Date: Sat, 6 Mar 2010 09:06:20 -0800
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org, werner@guyane.dyn-o-saur.com,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
Message-ID: <20100306170620.GA24344@kroah.com>
References: <20100227051737.GA14976@kroah.com> <Pine.LNX.4.44L0.1002271215290.25155-100000@netrider.rowland.org> <20100303000938.GA3257@kroah.com> <d9def9db1003060830i52e4c1c5k824e5d8318d9a67c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db1003060830i52e4c1c5k824e5d8318d9a67c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 05:30:44PM +0100, Markus Rechberger wrote:
> On Wed, Mar 3, 2010 at 1:09 AM, Greg KH <greg@kroah.com> wrote:
> > On Sat, Feb 27, 2010 at 12:20:35PM -0500, Alan Stern wrote:
> >> On Fri, 26 Feb 2010, Greg KH wrote:
> >>
> >> > Hm, so it's back to the original idea of just doing a kzalloc of the
> >> > initial buffer, that should solve the problem that Marcus found.
> >> >
> >> > I'll go dig that back up and if you could test it, that would be most
> >> > appreciated.
> >>
> >> Here's a better solution. ?In theory we could copy just the individual
> >> packets from within the transfer buffer, but that would probably take
> >> longer than simply copying the whole buffer.
> >>
> >> (This was a little hasty; I haven't even compile-tested the patch.
> >> Some small fixes may be needed.)
> >
> > Markus, did you test this patch out?
> >
> 
> works properly with ISO, (bulk is not tested from my side). please
> merge asap this also affects scanners (SANE).

Great, Alan, care to resend this to me with a signed-off-by line so I
can get it queued up properly?

thanks,

greg k-h
