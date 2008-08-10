Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYHJVgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYHJVgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbYHJVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:36:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57542 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYHJVgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:36:46 -0400
Date: Sun, 10 Aug 2008 22:35:20 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [WATCHDOG] v2.6.27-rc watchdog fixes
Message-ID: <20080810213520.GA2847@flint.arm.linux.org.uk>
References: <20080810204527.GF2773@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810204527.GF2773@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 10:45:27PM +0200, Wim Van Sebroeck wrote:
> Hi Linus,
> 
> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> This will update the following files:
> 
>  MAINTAINERS                       |    6 ------
>  drivers/watchdog/Makefile         |    5 ++++-
>  drivers/watchdog/at91rm9200_wdt.c |    2 +-
>  drivers/watchdog/ixp4xx_wdt.c     |    2 +-
>  drivers/watchdog/shwdt.c          |   24 ++++++++++++------------
>  drivers/watchdog/txx9wdt.c        |    2 +-
>  drivers/watchdog/wdt285.c         |    2 +-
>  7 files changed, 20 insertions(+), 23 deletions(-)

Note that s3c2410_wdt still gives an additional warning that I've
fixed in my set of ARM watchdog fixes.

It would be nice to get _all_ the issues resolved.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
