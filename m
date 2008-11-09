Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYKITem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYKITem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbYKITec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:34:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53165 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755699AbYKITeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:34:31 -0500
Date: Sun, 9 Nov 2008 20:34:01 +0100
From: Pavel Machek <pavel@suse.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Peter Alfredsen <loki_val@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lee Howard <lee.howard@mainpine.com>, linux-kernel@vger.kernel.org
Subject: Re: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081109193357.GA1549@ucw.cz>
References: <20081106174341.GA8155@xolotl.n0ano.com> <200811061952.37490.loki_val@gentoo.org> <20081106191250.GA28514@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106191250.GA28514@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-11-06 19:12:50, Russell King wrote:
> On Thu, Nov 06, 2008 at 08:52:31PM +0200, Peter Alfredsen wrote:
> > It seems like a typo to me to.. That wording has been constant since the 
> > file drivers/serial/serial_8250_pci.c was created based on work in 
> > drivers/char/serial.c:
> > http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=33c0d1b0c3ebb61243d9b19ce70d9063acff2aac
> > serial_8250.c has the "or later" clause there.
> > 
> > But I suppose the best way is to ask the originator of that file. 
> > Russell, what say you?
> > Did you mean to license that file under GPL-2 or GPL-2+?
> 
> It was based upon the original serial.c by Ted T'so, but with some
> reworking to add a separate quirks table, and quite a number of cleanups.
> 
> My personal position is that code I author is GPLv2, and not GPLv2 or
> later.  So it's a question whether you consider that I'm the author
> of the code in that file, or whether you think it's Ted's with my
> contributions were under Ted's original terms.

Original poster wants GPLv3 version for use in grub-2. Would you be
willing to relicense your changes in serial_8250.c, so that he can do
that? Would Ted be willing to do that?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
