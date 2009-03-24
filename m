Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZCXXvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZCXXvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZCXXvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:51:06 -0400
Received: from kroah.org ([198.145.64.141]:38375 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516AbZCXXvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:51:03 -0400
Date: Tue, 24 Mar 2009 16:20:49 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: hooanon05@yahoo.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Q. DEBUG_FS and SYSFS config (Re: [RFC Aufs2 #3 2/2] split
	'xino' entry under sysfs)
Message-ID: <20090324232049.GC21479@kroah.com>
References: <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl> <20090320030608.GA2638@kroah.com> <5142.1237521581@jrobl> <20090320041811.GA3352@kroah.com> <6218.1237526149@jrobl> <20090320054437.GC3993@kroah.com> <2778.1237882600@jrobl> <20090324153329.GA13705@kroah.com> <ac3eb2510903240857l2b072ffay7c3e2e5683527a4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510903240857l2b072ffay7c3e2e5683527a4f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:57:16PM +0100, Kay Sievers wrote:
> On Tue, Mar 24, 2009 at 16:33, Greg KH <greg@kroah.com> wrote:
> 
> >> First, configure "normaly".
> >> General setup
> >>   [ ] Configure standard kernel features (for small systems)  --->
> >>
> >> $ egrep -i '(sysfs|debug_fs)' .config
> >> CONFIG_SYSFS_DEPRECATED=y
> >> CONFIG_SYSFS_DEPRECATED_V2=y
> >
> > You should disable those two options, no modern distro needs them
> > anymore.
> 
> In fact, all recent distros will no longer work correctly, because
> DEPRECATED disables features which are expected to be there today. I
> guess it's time to remove the *_V2 hack to reset the default value,
> and set the default of CONFIG_SYSFS_DEPRECATED=n?

Sounds like a good idea for 2.6.31.  Care to send a patch so we can keep
it in -next for a few months?

thanks,

greg k-h
