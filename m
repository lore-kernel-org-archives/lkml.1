Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZKQEBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZKQEBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 23:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZKQEBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 23:01:08 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:41103 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZKQEBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 23:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c4WEJ+wG1jnMMvqwslme1qhSqk7WrZu3GbRewWnG153ha73gXT8YxQMWWHzOGxSF7j
         PdnLL+rP6kaUEYYYnvLh7Qa2KLzirvHkJIMnBJz0mY+fSez5K4n+fl/3UmTbkGtcVi8O
         twFQHFs+8auklKHqlOGl+TU9mqUDD5FZ48Z6Q=
Date: Mon, 16 Nov 2009 20:01:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14626] oops on boot starting udev
Message-ID: <20091117040104.GA5792@core.coreip.homeip.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.fpF.zSdALB@chimera> <20091117011455.GA7977@kroah.com> <20091117020451.GA27967@core.coreip.homeip.net> <1258426743.9883.53.camel@no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258426743.9883.53.camel@no>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:59:03AM +0100, Soeren Sonnenburg wrote:
> On Mon, 2009-11-16 at 18:04 -0800, Dmitry Torokhov wrote:
> > On Mon, Nov 16, 2009 at 05:14:55PM -0800, Greg KH wrote:
> > > On Mon, Nov 16, 2009 at 11:37:48PM +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.31.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14626
> > > > Subject		: oops on boot starting udev
> > > > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > > > Date		: 2009-11-14 10:16 (3 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=125819380206800&w=4
> > > 
> > > This looks like an input core problem, as the evdev module was just
> > > loaded and died.
> > > 
> > > Any input developers have any ideas?
> > > 
> > 
> > 
> > Hmm, evdev does:
> > 
> > 	dev_set_name(&evdev->dev, "event%d", minor);
> > 
> > Not sure how it can go wrong...
> 
> Anything I should/could do to narrow it down a bit (apart from
> bisecting?).
> 

Umm, I looked through the changes between -rc6 and 7 but nothing jumped
out at me... You don't happen to have any local changes in your tree?

-- 
Dmitry
