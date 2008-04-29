Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYD2Wlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYD2Wlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYD2Wli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:41:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53567 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYD2Wlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:41:37 -0400
Date: Tue, 29 Apr 2008 23:35:41 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Adrian Bunk <bunk@kernel.org>,
       "Denis V. Lunev" <den@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-ID: <20080429223540.GA19471@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Randy Dunlap <rdunlap@xenotime.net>, Adrian Bunk <bunk@kernel.org>,
	"Denis V. Lunev" <den@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
References: <20080429182709.GB2898@cs181133002.pp.htv.fi> <20080429201704.GA31311@flint.arm.linux.org.uk> <20080429135902.504b6362.rdunlap@xenotime.net> <20080429211410.GD31311@flint.arm.linux.org.uk> <20080429225845.0f60eb72@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429225845.0f60eb72@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:58:45PM +0100, Alan Cox wrote:
> > So, between Monday midnight and Thursday morning, when do you expect me
> > to sort the resulting mess out, given that I was not even able to be
> > in front of a computer until about 10pm on Tuesday and Wednesday?
> 
> How about delegate some of the control to other people ? There's something
> wrong if it has to be you that sorts it out eveyr time - especially as you
> effectively manage as many platforms as everyone else put together right
> now.

I believe I pointed at the patch required to fix the problem via this
URL:

  http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=5010/1

A subset of that patch had also already been discussed between Philipp,
akpm and myself.  The URL also shows when it was applied (though not to
a branch of my tree I could've pushed into mainline at that stage.)

The fix was already known...  The fix had been pointed out by me during
the various mails I got about the breakage...  I'd effectively already
approved the fix by applying it...  And I had said I wouldn't be able to
sort it until Thursday.

Yes, maybe I should've said to Andrew "please grab this patch off this
URL and ensure it gets to Linus ASAP."  Hind sight is always a wonderful
thing.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
