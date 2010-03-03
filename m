Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0CCInr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:43:47 -0500
Received: from isilmar.linta.de ([213.133.102.198]:53520 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864Ab0CCInp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:43:45 -0500
Date: Wed, 3 Mar 2010 09:43:37 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
 deprecation)
Message-ID: <20100303084337.GA24920@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
 <20100303083010.GA22928@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303083010.GA22928@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Wed, Mar 03, 2010 at 08:30:11AM +0000, Russell King wrote:
> On Wed, Mar 03, 2010 at 08:59:44AM +0100, Dominik Brodowski wrote:
> > Please pull from that location insofar as you agree to continue with the
> > deprecation of the PCMCIA ioctl. Otherwise, I can prepare a branch
> > _without_ this controversial patch to pull from.
> 
> So you believe that disabling the button in the graphical environment
> to allow PCMCIA cards to be removed (such as CF cards) - leaving the
> user to merely pull out the CF card, while the FS is mounted, is a
> good idea?

In which graphical environment specifically?`Which graphical environment
failed to update how to issue card removal events[1] even though the old
interface has been marked as deprecated since July 2005, and clear and bold
warnings have been visible in dmesg since September 2005?

Thanks,
	Dominik

[1] Either
# echo 1 > /sys/class/pcmcia_socket/pcmcia_socket{0,1,...}/card_eject
or, if pcmciautils are used,
# pccardctl eject [socket]
