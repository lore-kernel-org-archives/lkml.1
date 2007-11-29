Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbXK2Q2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbXK2Q2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbXK2Q16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:27:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070AbXK2Q15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:27:57 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jcm@redhat.com>
To: James Morris <jmorris@namei.org>
Cc: tvrtko.ursulin@sophos.com,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
In-Reply-To: <Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
	 <Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Thu, 29 Nov 2007 11:27:45 -0500
Message-Id: <1196353666.6473.43.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 11:12 +1100, James Morris wrote:
> On Wed, 28 Nov 2007, tvrtko.ursulin@sophos.com wrote:
> 
> > So as there is no question the current code does some ugly things it is 
> > even more true that we would be even more happy to use an official API. 
> 
> How about becoming involved in creating that official API ?

Sophos are interested in doing so, and we have spoken about this several
times recently over the phone. This is why they sent the email in
question yesterday, to kickstart debate. And that's awesome. I am trying
to bring a few of these folks together at the moment, so that we can get
a solution that is acceptable to upstream at some point in the future.

So, rather than criticise their current code, or their intentions, or
blanketly dismiss the virus protection market, perhaps we can focus
instead on the fact that there is a known third party who wishes to
perform a task that is not well supportable at this moment. We can all
agree the syscall table hacking isn't such a good idea - but these guys
are *very* open to listening to useful alternative suggestions.

They (virus protection folks) generally think they want to intercept
various system calls, such as open() and block until they have performed
a scan operation on the file. I explained the mmap issue to several of
these companies recently, in quite some detail, and I know they are
interested in listening this time around :-) At the end of the day, what
I have been lead to believe is that they don't care whether they
intercept syscall entries, or use a better method, they just want to
scan files and take some action if a file is "bad". That's it really.

I have been trying to put together an exact feature set that is needed
from these different vendors, so we can discuss it further here, and
hopefully actually get somewhere, too. There have been a few delays
after I pointed out the mmap issues at some length.

Jon.


