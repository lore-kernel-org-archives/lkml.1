Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZGTPW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZGTPW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZGTPW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:22:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZGTPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:22:56 -0400
Date: Mon, 20 Jul 2009 08:09:16 -0700
From: Greg KH <gregkh@suse.de>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720150916.GB10015@suse.de>
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907201613.22483.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 04:13:22PM +0200, Wolfgang Walter wrote:
> Am Montag, 20. Juli 2009 schrieb Greg KH:
> > I'm announcing the release of the 2.6.30.2 kernel.  All users of the
> > 2.6.30 kernel series are very strongly encouraged to upgrade.
> >
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.30.1 and 2.6.30.2
> >
> > The updated 2.6.30.y git tree can be found at:
> >        
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git and
> > can be browsed at the normal kernel.org git web browser:
> >        
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summa
> >ry
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Built 2.6.30.2 but it hangs when booting immediately after the message:
> 
> Booting the kernel.
> 
> I built it with gcc version 4.3.3 on debian/sid and used exactly the 
> same .config as I used with 2.6.32.1  (ok, + "DEFAULT_MMAP_MIN_ADDR 4096" 
> which didn't exist before).

Can you do 'git bisect' to see which patch caused the problem?  It might
be the one, "Don't use '-fwrapv' compiler option: it's buggy in
gcc-4.1.x", but it would be good to figure it out for sure.

thanks,

greg k-h
