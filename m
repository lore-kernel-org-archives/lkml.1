Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0CFCwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 21:52:15 -0500
Received: from foo.birdnet.se ([213.88.146.6]:48580 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752774Ab0CFCwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 21:52:14 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 21:52:13 EST
Message-ID: <20100306024450.29072.qmail@stuge.se>
Date: Sat, 6 Mar 2010 03:44:50 +0100
From: Peter Stuge <peter@stuge.se>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org, akpm@osdl.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
	deprecation)
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	torvalds@osdl.org, akpm@osdl.org,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <20100303083010.GA22928@flint.arm.linux.org.uk> <20100305120746.646126b9@lxorguk.ukuu.org.uk> <20100305214159.GB2994@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305214159.GB2994@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> > Do any graphical environments even support the ancient user space
> > pcmcica helper stuff ?
> 
> I believe so - the platform I have is based around the Open Embedded
> stuff, and there's a button on the desktop which communicates with the
> kernel via the PCMCIA ioctls.  One of the things it offers is to allow
> media (eg, CF) to be safely ejected without ending up pulling the card
> out while the FS is still mounted.

So if you upgrade that system to a kernel without that call I guess
you may have to either also upgrade that GUI software, or install a
.so to wrap ioctl() and provide backwards compatibility for the app?


//Peter
