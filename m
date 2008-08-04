Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYHDLfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYHDLfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbYHDLfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:35:45 -0400
Received: from www17.your-server.de ([213.133.104.17]:38106 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYHDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:35:44 -0400
Message-ID: <1217849719.4896e9771be61@213.133.104.17>
Date: Mon, 04 Aug 2008 13:35:19 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: next-20080725: System hangs while suspending to disk
References: <1217145731.3053.6.camel@dhcppc2> <20080804112811.GA12844@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080804112811.GA12844@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.226.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Pavel Machek <pavel@suse.cz>:

> > I tried to get some console output, so i tried "test" instead of
> > plattform and got an oops in native_cpu_up().
> > 
> > When i do "echo 0 > /sys/devices/system/cpu/cpu1/online" and
> > "echo 1 > /sys/devices/system/cpu/cpu1/online" again, i get the
> > same Oops report (as compared to a "test run with state disk")
> > 
> >
>
http://kerneloops.org/guilty.php?guilty=native_cpu_up&version=2.6.26-release&start=1736704&end=1769471&class=oops
> > 
> > What is wrong here?
> 
> You may want to ping cpu hotplug people.

Problem is already solved. See commit 583323b9d2f624884a8c9563fb5a4d795f39ab07

Vegard Nossum did take care of the problem. See also thread "-git: BUG: unable
to handle kernel paging request at c0100248 [CPU hotplug]" from 27.07.

Suspending to disk works fine now.


