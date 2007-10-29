Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbXJ2Tr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbXJ2Tr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXJ2TpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:45:06 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46592 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbXJ2TpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:45:04 -0400
Date: Mon, 29 Oct 2007 15:45:03 -0400
To: Stefan Roese <stefan.roese@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bootup support for watchdog with short timeout (touch_nmi_watchdog()?)
Message-ID: <20071029194503.GB27646@csclub.uwaterloo.ca>
References: <200710291522.27311.stefan.roese@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710291522.27311.stefan.roese@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 03:22:27PM +0100, Stefan Roese wrote:
> I'm trying to implement support for a board specific watchdog on a PPC440EPx 
> board with a very short timeout. In this case, the watchdog has to 
> be "kicked" at least every 100ms, even while booting and the real watchdog 
> driver not running yet. While looking for trigger places in the kernel 
> source, I noticed the already existing "touch_nmi_watchdog()" function, which 
> seems to be doing what I need. Even if the name not exactly matches my 
> hardware setup.
> 
> My question now is, is it recommended to use this 
> touch_nmi_watchdog() "infrastructure" for my PPC custom specific watchdog 
> during bootup? And if yes, should it perhaps be renamed to a more generic 
> name, like "touch_watchdog"?
> 
> Please advise. Thanks.

No idea really.  Who would design a watchdog with such a short trigger
time?  That doesn't seem to be useful in any way.

--
Len Sorensen
