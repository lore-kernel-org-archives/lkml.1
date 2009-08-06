Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZHFUDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZHFUDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 16:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZHFUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 16:03:17 -0400
Received: from kroah.org ([198.145.64.141]:36320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639AbZHFUDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 16:03:16 -0400
Date: Thu, 6 Aug 2009 12:58:48 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <teheo@suse.de>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
Message-ID: <20090806195848.GA29827@kroah.com>
References: <4A79283E.7030202@kernel.org>
 <20090805161643.GA28436@kroah.com>
 <4A79B3A6.7090109@kernel.org>
 <20090805164919.GA27457@kroah.com>
 <4A79BB04.8000408@kernel.org>
 <20090805171547.GB10443@kroah.com>
 <4A7A6FAE.8020503@kernel.org>
 <4A7A90AB.3050407@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A90AB.3050407@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:13:31PM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > Hello,
> > 
> > Greg KH wrote:
> >> Yes the names are confusing, the whole api needs a rework to make it
> >> easier to understand :(
> > 
> > For now, I'll open code it then but it would be really nice to clean
> > the names up.
> 
> Crap, there's a difference.  For [un]register_chrdev() the chrdev
> layer keeps track of cdev while using cdev_alloc/add/del() directly
> requires the caller to keep track of the pointer.  Also, it's a bit of
> pain to open code the whole thing.
> 
> For now, it looks like adding the __ prefixed versions seems to be the
> proper solution.  It's strange to provide the helper interface only
> for full minor acquisitions anyway.  Let's do naming cleanup later.
> How does that sound?

Well, what's the odds that I can get you to do cleanup now?  :)

Sure, I'll take this, only if Takashi wants the other stuff that depends
on it.  Let me know.

thanks,

greg k-h
