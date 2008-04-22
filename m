Return-Path: <linux-kernel-owner+w=401wt.eu-S1762560AbYDVTuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762560AbYDVTuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763386AbYDVTt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:49:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60047 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762848AbYDVTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:49:55 -0400
Date: Tue, 22 Apr 2008 20:49:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Randy Dunlap <RANDY.DUNLAP@ORACLE.COM>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: pasic3 allmod/yesconfig build error
Message-ID: <20080422194933.GB9911@flint.arm.linux.org.uk>
References: <28221442.1208881240429.JavaMail.oracle@acsmt302.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28221442.1208881240429.JavaMail.oracle@acsmt302.oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 11:20:40AM -0500, Randy Dunlap wrote:
> allmodconfig and allyesconfig on $ARCH try to build the htc-pasic3 driver,
> but it fails due to wanting <asm/arch/pxa-regs.h>.
> 
> Should the Kconfig file be modified to build this driver only for $ARCH=arm ?

Known problem.  You're about the 4th person in the last 24 hours to
report this.

It's been known about since Sunday.  Unfortunately, Linus not responding
to emails until midnight (my time) on Monday meant that I've not been able
to do anything about it, despite having a fix (along with others) already
merged but not properly queued up (because I didn't know what Linus was
going to do.)

So... I'm not going to be able to properly sort my tree until Thursday.
Please ignore it until Friday.  Thanks.

(Please note that these reports are stressing me because I have the fix,
I've known about it for ages, but because of factors out of my control -
and community policy, in so far as "you do not change the tree you've asked
to be pulled from" I'd have been unable to resolve it and all the other
stupid breakage in that pull before anyone saw it.  I suppose what I
should've done was deleted the tree of kernel.org so Linus _couldn't_
pull it.)
