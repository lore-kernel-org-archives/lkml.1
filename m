Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbXLTWWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbXLTWWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765528AbXLTWVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:21:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32829 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763198AbXLTWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:21:21 -0500
Date: Thu, 20 Dec 2007 14:20:04 -0800
From: Greg KH <greg@kroah.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-ID: <20071220222004.GB16431@kroah.com>
References: <20071220003031.GA15129@kroah.com> <20071219223206.ada18362.randy.dunlap@oracle.com> <20071220212700.GB5808@kroah.com> <alpine.LFD.0.9999.0712201659360.10061@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712201659360.10061@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 05:03:35PM -0500, Robert P. J. Day wrote:
> On Thu, 20 Dec 2007, Greg KH wrote:
> 
> > How about:
> > 	- A ktype is the type of object that embeds a kobject.
> 
> if i were reading the above for the first time, i would have no idea
> what was being embedded where.  "embeds a kobject" where?  what's
> being embedded in what?  that sentence doesn't make it clear.  what's
> the current definition for a "struct kobject"?

Read on and hopefully you will learn more.  As the beginning of the
article states, you have to start somewhere, it's all a circular
reference in the end :)

> >         Every structure that embeds a kobject needs a corresponding ktype.
> 
> and if it does, whose responsibility is it to provide one?  mine?
> that's not clear.

Well, someone has to provide it, the code will not compile without
one...

> > 	  The ktype controls what happens to the kobject when it is
> > 	  created and destroyed.
> 
> i doubt that.   i wouldn't say that the ktype "controls" what happens,
> i would say that it "defines" what happens.  to control suggests
> active participation.

Well, it controls how it is destroyed, and it controls how the uevents
happen when it is created.  It is quite active :)

thanks,

greg k-h
