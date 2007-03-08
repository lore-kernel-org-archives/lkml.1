Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbXCHOUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbXCHOUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXCHOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:20:33 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3359 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXCHOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:20:30 -0500
Date: Thu, 8 Mar 2007 14:20:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Oleksiy Kebkal <kebkal@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070308142017.GB30023@flint.arm.linux.org.uk>
Mail-Followup-To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Oleksiy Kebkal <kebkal@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703071019.55896.rgetz@blackfin.uclinux.org> <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com> <200703080844.32157.rgetz@blackfin.uclinux.org> <20070308134800.GA30023@flint.arm.linux.org.uk> <45F01AA8.7010608@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F01AA8.7010608@gmx.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 03:16:08PM +0100, Carl-Daniel Hailfinger wrote:
> Hi,
> 
> On 08.03.2007 14:48, Russell King wrote:
> > As I've said already, having a console on the same port as your application
> > program is just asking for trouble.  All bets are off - the kernel _will_
> > corrupt your data stream in random places.
> > 
> > Don't do it - it will _NEVER_ be reliable.
> > 
> > Never, ever, mix kernel consoles with application serial ports.
> 
> Unless you want two machines to monitor each other via serial console and
> each of them has only one serial port. It's not perfect, but it works well
> enough despite all claims to the contrary.

That's fine - you're not sending application specific data which could
be corrupted by an inopportune kernel message.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
