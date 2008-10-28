Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbYJ1Ipp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbYJ1Ipp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYJ1Iph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:45:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34698 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYJ1Ipg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:45:36 -0400
Date: Tue, 28 Oct 2008 08:44:07 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-stable@vger.kernel.org,
       Stanislav Brabec <utx@penguin.cz>,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, metan@atrey.karlin.mff.cuni.cz,
       thommycheck@gmail.com, milan@ucw.cz
Subject: Re: [Patch 2.6.27] fix booting on Sharp Zaurus c3000
Message-ID: <20081028084407.GA7913@flint.arm.linux.org.uk>
References: <20081009091929.GE29957@atrey.karlin.mff.cuni.cz> <20081015101747.GB28824@atrey.karlin.mff.cuni.cz> <20081015113923.GA21756@flint.arm.linux.org.uk> <200810250001.04835.rjw@sisk.pl> <20081026184108.GB1847@ucw.cz> <20081027092512.9327b690.randy.dunlap@oracle.com> <20081027234246.ea5e3b8e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027234246.ea5e3b8e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:42:46PM -0700, Andrew Morton wrote:
> On Mon, 27 Oct 2008 09:25:12 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Sun, 26 Oct 2008 19:41:09 +0100
> > Pavel Machek <pavel@suse.cz> wrote:
> > > Yes, I guess it should go to stable.
> > > 
> > > commit 69fc7eed5f56bce15b239e5110de2575a6970df4
> > > Author: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Date:   Thu Oct 9 16:58:13 2008 +0100
> > > 
> > >     [ARM] 5300/1: fixup spitz reset during boot
> 
> Somebody applied this.

Yes, I did, on October 11th.

> > > +/**
> > > + * init_gpio_reset() - register GPIO as reset generator
> > > + *
> > > + * @gpio - gpio nr
> > > + * @output - set gpio as out/low instead of input during normal work
> > 
> > Use colon (':') after function parameters, not hyphen/dash.
> 
> Without doing that.

Comments received after the patch has been committed and sent to
Linus can't be retrospectively corrected.  Another patch is required.

Since it's a trivial documentation matter, don't we have someone
handling such patches?  Is Rusty still the Trivial Patch Monkey?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
