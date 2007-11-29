Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbXK2QxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbXK2QxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbXK2QxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:53:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113AbXK2QxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:53:03 -0500
Date: Thu, 29 Nov 2007 08:51:48 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jon Masters <jcm@redhat.com>
Cc: James Morris <jmorris@namei.org>, tvrtko.ursulin@sophos.com,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Out of tree module using LSM
Message-ID: <20071129085148.5dff3636@freepuppy.rosehill>
In-Reply-To: <1196353666.6473.43.camel@perihelion>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
	<Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au>
	<1196353666.6473.43.camel@perihelion>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 11:27:45 -0500
Jon Masters <jcm@redhat.com> wrote:

> On Thu, 2007-11-29 at 11:12 +1100, James Morris wrote:
> > On Wed, 28 Nov 2007, tvrtko.ursulin@sophos.com wrote:
> > 
> > > So as there is no question the current code does some ugly things it is 
> > > even more true that we would be even more happy to use an official API. 
> > 
> > How about becoming involved in creating that official API ?
> 
> Sophos are interested in doing so, and we have spoken about this several
> times recently over the phone. This is why they sent the email in
> question yesterday, to kickstart debate. And that's awesome. I am trying
> to bring a few of these folks together at the moment, so that we can get
> a solution that is acceptable to upstream at some point in the future.
> 
> So, rather than criticise their current code, or their intentions, or
> blanketly dismiss the virus protection market, perhaps we can focus
> instead on the fact that there is a known third party who wishes to
> perform a task that is not well supportable at this moment. We can all
> agree the syscall table hacking isn't such a good idea - but these guys
> are *very* open to listening to useful alternative suggestions.
> 
> They (virus protection folks) generally think they want to intercept
> various system calls, such as open() and block until they have performed
> a scan operation on the file. I explained the mmap issue to several of
> these companies recently, in quite some detail, and I know they are
> interested in listening this time around :-) At the end of the day, what
> I have been lead to believe is that they don't care whether they
> intercept syscall entries, or use a better method, they just want to
> scan files and take some action if a file is "bad". That's it really.
> 
> I have been trying to put together an exact feature set that is needed
> from these different vendors, so we can discuss it further here, and
> hopefully actually get somewhere, too. There have been a few delays
> after I pointed out the mmap issues at some length.
> 

Perhaps this kind of scanning belongs in the application. Couldn't an
apache or samba have a plugin to do it?

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
