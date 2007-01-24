Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbXAXVes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbXAXVes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXAXVes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:34:48 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:43554 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbXAXVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:34:48 -0500
Date: Wed, 24 Jan 2007 16:34:47 -0500
To: "Kilau, Scott" <Scott_Kilau@digi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070124213447.GB7584@csclub.uwaterloo.ca>
References: <335DD0B75189FB428E5C32680089FB9F012DCACD@mtk-sms-mail01.digi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335DD0B75189FB428E5C32680089FB9F012DCACD@mtk-sms-mail01.digi.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 03:19:53PM -0600, Kilau, Scott wrote:
> There are a couple interesting things I would do here.
> 
> 1) The tty "flip" buffer stuff was changed in 2.6.16+.
> 
> Maybe you could try going downwards to 2.6.15 or below and see if the
> problem
> still exists.

That looked like a lot of changes to the tty layer.  I think going up
sounds better.  Finding the bug fix and backporting it would be
preferable of course.

> Then try going up to 2.6.19, I believe there were some bugs fixed
> in 2.6.17/18/19, not sure how many of those made it backported into
> 2.6.16.25.

Well I can certainly compare the code between those versions, and I have
a 2.6.18 kernel I could try out too.

> 2) Try using Digi's "Out-Of-Kernel-Source-Tree"/GPL version of the
> driver.
> You can grab the latest and greatest beta version of it from here:
> ftp://ftp1.digi.com/support/beta/linux/dgnc/
> Its in source rpm format, let me know if you need it in a tarball format
> instead.

Yes, I run Debian.  rpm has very little interest.  I can convert it
though.

> You obviously will have to add in your specific PCI id into the driver,
> but that should be a problem.

I did that.

> 3) I seem to recall that someone mentioned that the Exar 17D154 PCI
> chips were
> easily "pushed" into the 8250 driver.
> It might be interesting to try that route as well.

I am using the GPIO lines too, and didn't want to mess with the 8250
driver (since I use that for a serial console on a 16550 UART), plus
being able to use the 64byte fifo rather than 16byte 16550 mode fifo
seems nicer.  I had to take the exar out of the 8250 driver to make it
not take control of it (although now the eeprom has been added to the
board so it no longer appears as a generic exar chip).

Thanks for the suggestions though.  Gives me a few things to try.

--
Len Sorensen
