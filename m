Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0CCId6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:33:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51005 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0CCId5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:33:57 -0500
Date: Wed, 3 Mar 2010 08:30:11 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: torvalds@osdl.org, akpm@osdl.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
	deprecation)
Message-ID: <20100303083010.GA22928@flint.arm.linux.org.uk>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
References: <20100303075944.GA23354@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303075944.GA23354@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:59:44AM +0100, Dominik Brodowski wrote:
> Please pull from that location insofar as you agree to continue with the
> deprecation of the PCMCIA ioctl. Otherwise, I can prepare a branch
> _without_ this controversial patch to pull from.

So you believe that disabling the button in the graphical environment
to allow PCMCIA cards to be removed (such as CF cards) - leaving the
user to merely pull out the CF card, while the FS is mounted, is a
good idea?

Sounds to me like a data loss scenario.

User APIs changing always breaks stuff.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
