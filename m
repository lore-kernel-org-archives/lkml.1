Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZE1Vp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZE1Vp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZE1VpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:45:20 -0400
Received: from kroah.org ([198.145.64.141]:37628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZE1VpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:45:19 -0400
Date: Thu, 28 May 2009 14:41:41 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name
	to mount debugfs filesystem.
Message-ID: <20090528214141.GA10079@kroah.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com> <20090526205414.GA26016@kroah.com> <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com> <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com> <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com> <1243403437.3118.10.camel@localhost.localdomain> <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com> <20090527191310.GA466@kroah.com> <alpine.DEB.2.00.0905280929190.27708@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905280929190.27708@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 09:45:51AM -0400, Steven Rostedt wrote:
> > I'm sorry you have to type a long path, perhaps you wish to invest in a
> > tab key for auto-completion :)
> > 
> > Again, distros already mount debugfs at this location, please don't
> > confuse people just because you are annoyed at the length of the path.
> 
> Have you found which packages do that?

The base system packages on all openSUSE and SLE11 releases.  Possibly
SLE10 also does it, but I don't have a running instance of that at the
moment.

> The point is that the document is more interested in showing the files 
> that are being used, and if I add /sys/kernel/debug/ in front of every 
> file, that just distracts from the eye. As stated:
> 
>   "but for simplicity this document will use /debug"

Sorry for the "distraction", but that goes against documentation on your
machine:
	$ man mount | grep -A 3 "Mount options for debugfs"
	Mount options for debugfs
	       The debugfs file system is a pseudo file system, traditionally  mounted
	       on /sys/kernel/debug.  There are no mount options.

It's not only a documented standard, it's a "tradition" :)

Please fix your documentation.

thanks,

greg k-h
