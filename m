Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYJGDmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYJGDmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 23:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYJGDmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 23:42:45 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:6163 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbYJGDmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 23:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eFyHgeBSHFntGJIjQjL9WfHFuYzZmERE3VqGCwoQieHsG98HICF0LPCRGhdK4IaAUY
         7JxDCiL3EYfUIr5zDBuJDa4blXJjMzp2MHVV6xeldMoNKiu9JaMJ0jMLORoEotpRWqxe
         76QkM4oqM6x/ZEUZlBGyWY119NdRILEIg6FX0=
Date: Mon, 6 Oct 2008 23:42:35 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
Message-ID: <20081007034230.GA6095@amd.corenet.prv>
References: <20081005183603.GA3263@amd.corenet.prv> <20081005121046.579089b9@infradead.org> <20081006062838.GC2808@amd.corenet.prv> <20081006195350.GB22097@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006195350.GB22097@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 09:53:50PM +0200, Andreas Herrmann wrote:
> On Mon, Oct 06, 2008 at 02:28:39AM -0400, Dmitry Torokhov wrote:
> > On Sun, Oct 05, 2008 at 12:10:46PM -0700, Arjan van de Ven wrote:
> > > On Sun, 5 Oct 2008 14:36:25 -0400
> > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > speed, fans are constantly on, everything seems sluggish.
> > > > 
> > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > somewhere in tty_init.
> > > 
> > > hpet=force is a "the kernel thinks it's not wise to use, but you think
> > > better"... don't do that ;(
> > > 
> > 
> > That is not how I parse dmesg:
> > 
> > [    0.077927] HPET not enabled in BIOS. You might try hpet=force boot
> > option
> > 
> > Here kernel recommends to try and enable it. If we generally don't recommed
> > using 'force' I'd suggest removing the 2nd sentence from the message.
> 
> FYI.
> Commit e7250b8ae3870f37f660c2f65cafcaba85e3bfd3 of tip/master is
> needed to really enable hpet on SB400. I guess that patch should go
> upstream asap -- and probably it's a good idea to add a check for timer
> interrupt routing as well which could solve the issues on HP nx6xxx
> laptops.
> 

Having trouble locating this one. Could you please send me a patch so I
can try it here? Thanks!

-- 
Dmitry
