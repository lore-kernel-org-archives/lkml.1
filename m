Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXCVPIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXCVPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933106AbXCVPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:08:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3709 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933092AbXCVPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:08:22 -0400
Date: Tue, 20 Mar 2007 11:54:03 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Maxim <maximlevitsky@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: sysfs ugly timer interface (was Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far)
Message-ID: <20070320115403.GA3983@ucw.cz>
References: <200703161230.03712.maximlevitsky@gmail.com> <200703161919.44458.lenb@kernel.org> <200703180100.01889.maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703180100.01889.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> root@MAIN:/home/maxim# cat /sys/devices/system/clockevents/clockevents0/registered
> lapic                F:0007 M:3(periodic) C: 1
> hpet                 F:0003 M:1(shutdown) C: 0
> lapic                F:0007 M:3(periodic) C: 0
> root@MAIN:/home/maxim#   

Now... this file needs to die, before 2.6.21 is released. It tries to
bring /proc-like parsing nightmare to sysfs. Kill it before it becomes
part of stable ABI!
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
