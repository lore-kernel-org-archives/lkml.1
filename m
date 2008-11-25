Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYKYEvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYKYEvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYKYEvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:51:22 -0500
Received: from blaine.gmane.org ([80.91.229.8]:57396 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbYKYEvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:51:22 -0500
Date: Mon, 24 Nov 2008 20:20:51 -0800
From: Greg KH <gregkh@suse.de>
To: Junio C Hamano <gitster@pobox.com>
Cc: Linus Torvalds 
	<public-torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Andrew Morton 
	<public-akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@hugh.gmane.org>,
       Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.28-git
Message-ID: <20081125042051.GA17345@suse.de>
References: <20081120055026.GA10709@kroah.com> <alpine.LFD.2.00.0811201322350.21698@nehalem.linux-foundation.org> <20081120214826.GA15769@suse.de> <7vprkklaob.fsf@gitster.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vprkklaob.fsf@gitster.siamese.dyndns.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-TMDA-Confirmed: Tue, 25 Nov 2008 05:51:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, Nov 24, 2008 at 07:57:40PM -0800, Junio C Hamano wrote:
> 
> 
> Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org> writes:
> 
> > On Thu, Nov 20, 2008 at 01:23:51PM -0800, Linus Torvalds wrote:
> >> 
> >> 
> >> On Wed, 19 Nov 2008, Greg KH wrote:
> >> > 
> >> > Please pull from:
> >> > 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
> >> 
> >> "Already up-to-date". 
> >> 
> >> I think you forgot to actually push them out.
> >
> > Crap, you're right, they are now there, sorry about that.
> 
> I've been wondering if git can do something to avoid things like this.
> 
> For example, if you push into a particular branch of a particular
> repository _only_ to ask Linus to pull and for no other purpose, one
> possible solution may be to trigger a hook on the receiving end of your
> push (i.e. the public repository Linus is asked to pull from) to send out
> the "Please pull from" message (I presume this would be a no-go as there
> is not much room for you to customize the message).
> 
> Alternatively, we may want to give an option to git-request-pull to
> actually run "git push" to the destination.
> 
> Thoughts?  Is it "none of Git's business"?

In this case, it was just my fault.  I just forgot to push the tree.  I
have my own scripts that I use to create my "please pull" message, that
don't really tie into git's infrastructure and I don't know if I would
want them to either.

thanks,

greg k-h


