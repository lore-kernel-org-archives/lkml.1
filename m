Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZHGEHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZHGEHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZHGEHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:07:04 -0400
Received: from kroah.org ([198.145.64.141]:45024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZHGEHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:07:03 -0400
Date: Thu, 6 Aug 2009 21:05:54 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <teheo@suse.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
Message-ID: <20090807040554.GB24046@kroah.com>
References: <4A79283E.7030202@kernel.org>
 <20090805161643.GA28436@kroah.com>
 <4A79B3A6.7090109@kernel.org>
 <20090805164919.GA27457@kroah.com>
 <4A79BB04.8000408@kernel.org>
 <20090805171547.GB10443@kroah.com>
 <4A7A6FAE.8020503@kernel.org>
 <4A7A90AB.3050407@suse.de>
 <20090806195848.GA29827@kroah.com>
 <4A7B92CC.2080006@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7B92CC.2080006@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 11:34:52AM +0900, Tejun Heo wrote:
> Hello, Greg.
> 
> Greg KH wrote:
> >> For now, it looks like adding the __ prefixed versions seems to be the
> >> proper solution.  It's strange to provide the helper interface only
> >> for full minor acquisitions anyway.  Let's do naming cleanup later.
> >> How does that sound?
> > 
> > Well, what's the odds that I can get you to do cleanup now?  :)
> 
> I'd be happy to but whether cleaning it up would be benefitial or not
> is a bit unclear.  We have 214 users of [un]register_chrdev_region()
> and 118 users of [un]register_chrdev().  So, renaming the latter to,
> say, create/destroy_chrdev() and make it take @baseminor and
> @nr_minors should do it but I'm not quite sure whether it would worth
> touching all those files.  Maybe it's better left as a mess like the
> page allocation functions?

Yeah, I guess it's easier to leave it alone for now.  If I ever get
bored, I'll work on cleaning them up :)

thanks,

greg k-h
