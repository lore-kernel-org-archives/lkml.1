Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbYC1UIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbYC1UIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYC1UIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:08:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1323 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753700AbYC1UIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:08:38 -0400
Date: Fri, 28 Mar 2008 14:59:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Meyer <mike65134@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Message-ID: <20080328135946.GB4404@ucw.cz>
References: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-25 14:47:50, Michael Meyer wrote:
> Hi, 
> 
> what is the difference between booting a dual core
> machine with "maxcpus=1" or by deactivating the second
> core at run time with "echo 0 >
> /sys/devices/system/cpu/cpu1/online"?

maxcpus=1 : core stays powered off
0 > online : core enters halt.

> I observed a funny behaviour of apache ant: although
> it uses javac which is single threaded, a compile run
> with "maxcpus=1" is actually faster than a compile run
> with both cores activated. But with the second core
> deactivated using "echo 0 >
> /sys/devices/system/cpu/cpu1/online" it is even slower
> than with both cores.

Thermal fun? Check cooling.


> Is here any method to get the exact same behaviour of
> "maxcpus=1" with disabling the second core only
> temporarily? So that the second core could be disabled
> before the ant execution and enabled after the ant
> execution?

Patch pushing 0 > online cores into C4 would be nice.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
