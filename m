Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZDXXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZDXXDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZDXXDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 19:03:00 -0400
Received: from kroah.org ([198.145.64.141]:50225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbZDXXC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 19:02:59 -0400
Date: Fri, 24 Apr 2009 15:51:22 -0700
From: Greg KH <greg@kroah.com>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, LKML <linux-kernel@vger.kernel.org>,
       Comedi-ml <comedi_list@googlegroups.com>
Subject: Re: RFC about Comedi on a patch that remove a lot fo code
Message-ID: <20090424225122.GB3343@kroah.com>
References: <63a49ef40904240228g6a28ba8dsf63d2e0bdc6b57d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a49ef40904240228g6a28ba8dsf63d2e0bdc6b57d9@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:28:28AM +0200, Alessio Igor Bogani wrote:
> Dear Comedi developers,
> 
> Sorry for my bad english.
> 
> I would be happy to receive your considerations about that patch:
> 
> http://marc.info/?l=linux-next&m=123792129500760&w=2
> 
> I know that some users use Comedi on dual kernel approach systems.
> Obviously I don't have any against this but i think that Linux git
> tree isn't the right place to support those software (RTAI, Xenomai,
> RTLinux and others). Those projects already released patches against
> Linux source code so it very easy for them add also patch for Comedi
> drivers in the same tarball.
> 
> At the already listed 8 reasons  in that email I want added a ninth one:
> 9) Give more chance for interested developers to fix it against RT_PREEMPT
> http://marc.info/?l=linux-rt-users&m=124049407712792&w=2

I am siding with you, and agree all of the RT stuff should be deleted
from the in-kernel comedi code, as there is on in-kernel users of it.

Also, the recent Linux RT changes will not need any of these
driver-specific changes at all from what I can tell, so they are now
obsolete.

Frank, unless you have any major objections, I'd like to remove this
code.

thanks,

greg k-h
