Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbXEYMnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbXEYMnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXEYMnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:43:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40491 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbXEYMm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:42:58 -0400
X-Greylist: delayed 8555 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 08:42:58 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4656D923.8040703@s5r6.in-berlin.de>
Date: Fri, 25 May 2007 14:40:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: crn@netunix.com
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com>
In-Reply-To: <4656CE39.8050800@netunix.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Newport wrote:
> There is a fundamental problem in getting  a decent log to debug  a
> crashed kernel.

If the test machine and a 2nd machine have FireWire ports, it's possible
to get the kernel log and more via FireWire, unless the machine rebooted
immediately or the PCI bus locked up.  The program 'firescope' and the
raw1394 driver is needed on the 2nd machine; the test machine has to
have ohci1394 loaded.
-- 
Stefan Richter
-=====-=-=== -=-= ==--=
http://arcgraph.de/sr/
