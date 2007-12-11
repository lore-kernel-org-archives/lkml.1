Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXLKQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXLKQvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXLKQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:51:38 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48414 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLKQvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:51:38 -0500
Message-ID: <475EBFBA.6090301@keyaccess.nl>
Date: Tue, 11 Dec 2007 17:50:02 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net, dpreed@reed.com
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org>
In-Reply-To: <20071211163017.GD16750@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 17:30, Andi Kleen wrote:

> Anyways it looks like the discussion here is going in a
> a loop. I had hoped David would post his test results with
> another port so that we know for sure that the bus aborts 
> (and not port 80) is the problem on his box. But it looks like
> he doesn't want to do this. Still removing the bus aborts
> is probably the correct way to go forward.

Yes, I do also still want to know that. David (Reed)?

> Only needs a patch now. If nobody beats me to it i'll
> add one later to my tree.

Pavel Machek already posted one. His udelay(8) wants to be less -- 1 or "to 
be safe" perhaps 2.

http://lkml.org/lkml/2007/12/9/131

Rene.
