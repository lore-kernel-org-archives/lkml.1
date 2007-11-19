Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbXKSPzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbXKSPzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXKSPz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:55:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41659 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXKSPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:55:27 -0500
Date: Mon, 19 Nov 2007 15:55:07 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 21285: Report baud rate back via termios
Message-ID: <20071119155507.GB30129@flint.arm.linux.org.uk>
References: <20071119151222.6cfa9c4c@the-village.bc.nu> <20071119154137.GA30129@flint.arm.linux.org.uk> <20071119155007.6cfdce37@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119155007.6cfdce37@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 03:50:07PM +0000, Alan Cox wrote:
> On Mon, 19 Nov 2007 15:41:37 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > On Mon, Nov 19, 2007 at 03:12:22PM +0000, Alan Cox wrote:
> > > Currently reports back the requested rate not the result of the divides
> > > but thats an easy fix for someone with h/w
> > > 
> > > Signed-off-by: Alan Cox <alan@redhat.com>
> > 
> > Ack for first hunk.  When can this be merged?  I assume it has to wait
> > for tty_encode_baud_rate() to appear in mainline?
> 
> tty_termios_encode_baud-rate/tty_encode_baud_rate are now in mainline

Great, I'll queue it for the next merge minus the 2nd hunk.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
