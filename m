Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXBAJ7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXBAJ7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 04:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422733AbXBAJ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 04:59:03 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:55118 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422716AbXBAJ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 04:59:00 -0500
Date: Thu, 1 Feb 2007 10:59:04 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-mips@linux-mips.org
Message-ID: <20070201095904.GE8882@enneenne.com>
References: <20070129230755.GA8705@enneenne.com> <20070130010055.GA15907@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130010055.GA15907@linux-sh.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Advice on battery support [was: Advice on APM-EMU reunion]
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 10:00:55AM +0900, Paul Mundt wrote:

> However, it has since been reposted:
> 
> http://article.gmane.org/gmane.linux.kernel/485833
> http://article.gmane.org/gmane.linux.kernel/485834
> http://article.gmane.org/gmane.linux.kernel/485835
> http://article.gmane.org/gmane.linux.kernel/485837
> 
> and merged back in to -mm. This is all post 2.6.20 stuff, though..

Ok, starting from these patches I'd like to add a "battery support" to
the kernel.

What I suppose to do is a new class with a proper methods useful to
collect several info on battery status, such as get_ac_line_status()
get_battery_status(), get_battery_flags(),
get_remaining_battery_life() and so on.

The output will be APM-like into file "/proc/apm" (one line per
battery, or just the "main"/first one?) so that existing applications
continue to work and under sysfs into "/sysfs/class/battery".

Is it sane? :)

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
