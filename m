Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYAFAhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYAFAhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYAFAhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:37:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53889 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYAFAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:37:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47802249.9010107@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 01:35:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist>
In-Reply-To: <20080105234540.GG22232@does.not.exist>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Whether or not an option requires an additional subsystem like e.g. SCSI 
> or SSB are hardware and implementation details we shouldn't bother 
> kconfig users with.

What is an implementation detail and what is not?  In the end,
everything that we configure in Kconfig is implementation details.

PS:
Kill 'select' already, and instead work on better UIs if you have got
trouble with the complexities of the dependencies graph.  The graphic
UIs including menuconfig currently work best for tree-like dependencies,
but the graph isn't a tree.  Think about how to present this properly in
an UI.  The Kconfig files are the wrong place to attack this problem.

PPS:
Really, it's *not* hard *at all* to configure a 2.6.24-rc6 kernel with
USB storage support.  I don't read linux-usb --- has there been repeated
questions how to enable usb-storage in the kernel configuration?  I can
tell you that there has been no such question about sbp2 (FireWire
storage support) in years.  Don't fix what ain't broken.  In fact, don't
/break/ what ain't broken by adding more of the (as yet) broken 'select'
everywhere.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
