Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYHDL2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYHDL2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYHDL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:28:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47650 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYHDL2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:28:12 -0400
Date: Mon, 4 Aug 2008 13:28:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: next-20080725: System hangs while suspending to disk
Message-ID: <20080804112811.GA12844@atrey.karlin.mff.cuni.cz>
References: <1217145731.3053.6.camel@dhcppc2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217145731.3053.6.camel@dhcppc2>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tried to get some console output, so i tried "test" instead of
> plattform and got an oops in native_cpu_up().
> 
> When i do "echo 0 > /sys/devices/system/cpu/cpu1/online" and
> "echo 1 > /sys/devices/system/cpu/cpu1/online" again, i get the
> same Oops report (as compared to a "test run with state disk")
> 
> http://kerneloops.org/guilty.php?guilty=native_cpu_up&version=2.6.26-release&start=1736704&end=1769471&class=oops
> 
> What is wrong here?

You may want to ping cpu hotplug people.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

