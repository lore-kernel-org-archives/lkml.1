Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZGTToc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZGTToc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 15:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZGTTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 15:44:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:49678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbZGTTob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 15:44:31 -0400
Date: Mon, 20 Jul 2009 12:42:29 -0700
From: Greg KH <gregkh@suse.de>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>,
       Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720194229.GB29819@suse.de>
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
 <20090720180333.GA2905@brouette>
 <20090720212318.2aa5be21@varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090720212318.2aa5be21@varda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:23:18PM +0200, Alejandro Riveira Fernández wrote:
> El Mon, 20 Jul 2009 20:03:33 +0200
> Damien Wyart <damien.wyart@free.fr> escribió:
> 
> > > > Built 2.6.30.2 but it hangs when booting immediately after the message:
> > 
> > > > Booting the kernel.
> > 
> > > > I built it with gcc version 4.3.3 on debian/sid and used exactly the
> > > > same .config as I used with 2.6.32.1 (ok, + "DEFAULT_MMAP_MIN_ADDR
> > > > 4096" which didn't exist before).
> > 
> > * Greg KH <gregkh@suse.de> [2009-07-20 08:09]:
> > > Can you do 'git bisect' to see which patch caused the problem? It
> > > might be the one, "Don't use '-fwrapv' compiler option: it's buggy in
> > > gcc-4.1.x", but it would be good to figure it out for sure.
> > 
> > I am seeing a similar problem (no hang but an immediate reboot) on the
> > same distro. I tried to bisect but got no good kernel in the end.
> > 
> > To clarify things I recompiled again 2.6.30.1 with the orginial .config
> > and it also failed to boot (I was happy to have renamed it so the
> > working kernel was still available). I suspected a recent gcc 4.3
> > upgrade so downgraded gcc, but no luck, still getting the same problem.
> > So for now I am quite stuck, but there is clearly a bad problem
> > somewhere...
> > 
> I did not have any probelm with the gcc shipped in ubuntu gcc (Ubuntu
> 4.3.3-5ubuntu4) 4.3.3 (64 bit jaunty 9.04)
> 
> All three 2.6.30 2.6.30.1 and .2 boot just fine (i carry a revert but i
> doubt it changes things)

What revert do you find needed?

thanks,

greg k-h
