Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYAFBE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYAFBE0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYAFBEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:04:14 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:63529 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYAFBEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:04:13 -0500
Message-ID: <47802879.3080005@oracle.com>
Date: Sat, 05 Jan 2008 17:01:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist> <47802249.9010107@s5r6.in-berlin.de>
In-Reply-To: <47802249.9010107@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Adrian Bunk wrote:
>> Whether or not an option requires an additional subsystem like e.g. SCSI 
>> or SSB are hardware and implementation details we shouldn't bother 
>> kconfig users with.
> 
> What is an implementation detail and what is not?  In the end,
> everything that we configure in Kconfig is implementation details.
> 
> PS:
> Kill 'select' already, and instead work on better UIs if you have got
> trouble with the complexities of the dependencies graph.  The graphic
> UIs including menuconfig currently work best for tree-like dependencies,
> but the graph isn't a tree.  Think about how to present this properly in
> an UI.  The Kconfig files are the wrong place to attack this problem.
> 
> PPS:
> Really, it's *not* hard *at all* to configure a 2.6.24-rc6 kernel with
> USB storage support.  I don't read linux-usb --- has there been repeated
> questions how to enable usb-storage in the kernel configuration?  I can

I do read linux-usb.  I don't think that USB storage configuration
is a big issue (currently, without using "select").
But that's just my take on it.

> tell you that there has been no such question about sbp2 (FireWire
> storage support) in years.  Don't fix what ain't broken.  In fact, don't
> /break/ what ain't broken by adding more of the (as yet) broken 'select'
> everywhere.


-- 
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
