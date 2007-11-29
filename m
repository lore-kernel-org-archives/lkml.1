Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbXK2QwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbXK2QwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbXK2QwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:52:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893AbXK2QwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:52:09 -0500
Date: Thu, 29 Nov 2007 08:51:04 -0800
From: Greg KH <greg@kroah.com>
To: Jon Masters <jcm@redhat.com>
Cc: James Morris <jmorris@namei.org>, tvrtko.ursulin@sophos.com,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129165104.GC9664@kroah.com>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com> <Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au> <1196353666.6473.43.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196353666.6473.43.camel@perihelion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:27:45AM -0500, Jon Masters wrote:
> On Thu, 2007-11-29 at 11:12 +1100, James Morris wrote:
> > On Wed, 28 Nov 2007, tvrtko.ursulin@sophos.com wrote:
> > 
> > > So as there is no question the current code does some ugly things it is 
> > > even more true that we would be even more happy to use an official API. 
> > 
> > How about becoming involved in creating that official API ?
> 
> Sophos are interested in doing so, and we have spoken about this several
> times recently over the phone.

Great, but this email did not show that they were interested in doing
so.

> So, rather than criticise their current code, or their intentions, or
> blanketly dismiss the virus protection market, perhaps we can focus
> instead on the fact that there is a known third party who wishes to
> perform a task that is not well supportable at this moment. We can all
> agree the syscall table hacking isn't such a good idea - but these guys
> are *very* open to listening to useful alternative suggestions.

It's not only not a good idea, it's insecure and is trivial to
circumvent, so it's a non-issue here.

> They (virus protection folks) generally think they want to intercept
> various system calls, such as open() and block until they have performed
> a scan operation on the file. I explained the mmap issue to several of
> these companies recently, in quite some detail, and I know they are
> interested in listening this time around :-) At the end of the day, what
> I have been lead to believe is that they don't care whether they
> intercept syscall entries, or use a better method, they just want to
> scan files and take some action if a file is "bad". That's it really.

Yes, I too have talked with people doing this kind of work, see my other
messages in this thread for how it can be done all in userspace, no
kernel changes needed at all.

thanks,

greg k-h
