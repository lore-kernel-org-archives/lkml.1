Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0CEVmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:42:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58747 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0CEVme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:42:34 -0500
Date: Fri, 5 Mar 2010 21:41:59 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@osdl.org, akpm@osdl.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
	deprecation)
Message-ID: <20100305214159.GB2994@flint.arm.linux.org.uk>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
	akpm@osdl.org, "Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <20100303083010.GA22928@flint.arm.linux.org.uk> <20100305120746.646126b9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305120746.646126b9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 12:07:46PM +0000, Alan Cox wrote:
> > So you believe that disabling the button in the graphical environment
> > to allow PCMCIA cards to be removed (such as CF cards) - leaving the
> > user to merely pull out the CF card, while the FS is mounted, is a
> > good idea?
> 
> Do any graphical environments even support the ancient user space
> pcmcica helper stuff ? I can't find any evidence they do but I realise
> Russell you get to deal with assorted crazy ARM embedded setups.

I believe so - the platform I have is based around the Open Embedded
stuff, and there's a button on the desktop which communicates with the
kernel via the PCMCIA ioctls.  One of the things it offers is to allow
media (eg, CF) to be safely ejected without ending up pulling the card
out while the FS is still mounted.

If the button can't communicate with the kernel PCMCIA driver, it doesn't
know that a CF card is in place, so it can't offer to eject the media.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
