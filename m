Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZKYPlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZKYPlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZKYPlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:41:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZKYPlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:41:13 -0500
Date: Wed, 25 Nov 2009 07:41:06 -0800
From: Greg KH <gregkh@suse.de>
To: eran liberty <eran.liberty@gmail.com>
Cc: balajirrao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: kobjects: mark cleaned up kobjects as unitialized
Message-ID: <20091125154106.GA24842@suse.de>
References: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com>
 <20091125123534.GA17486@suse.de>
 <ffc2b1d40911250627q6c7e459v89a580d793b24fcf@mail.gmail.com>
 <20091125152747.GB24498@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125152747.GB24498@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 07:27:47AM -0800, Greg KH wrote:
> > but basically you can demonstrate the problem with this simple code:
> > 
> > struct device dev;
> > while(1) {
> >   dev->release = dummy_release_function_that_does_nothing;
> 
> WTF!!!
> 
> Ugh, if I see one more person try to "trick" the kernel from reporting
> this error by providing a "dummy" release function, I'm going to go find
> a kitten to kick.
> 
> Seriously, why are you blatently ignoring the warning that the kernel is
> trying to be nice and give to you?  Do we just invent messages that need
> to be worked around?

Oh, and before anyone thinks that I'm being too harsh here, again, refer
to Documentation/kobject.txt:
	Note that the kernel will warn you if you forget to provide a
	release() method.  Do not try to get rid of this warning by
	providing an "empty" release function; you will be mocked
	mercilessly by the kobject maintainer if you attempt this.

Hence my mocking.

thanks,

greg k-h
