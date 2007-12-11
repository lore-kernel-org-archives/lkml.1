Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXLKR3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXLKR3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXLKR31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:29:27 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45095 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbXLKR31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:29:27 -0500
Message-ID: <475EC895.2060207@keyaccess.nl>
Date: Tue, 11 Dec 2007 18:27:49 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <475EC246.10205@reed.com> <475EC320.5080008@keyaccess.nl>
In-Reply-To: <475EC320.5080008@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 18:04, Rene Herman wrote:

> On 11-12-07 18:00, David P. Reed wrote:
> 
>> Which port do you want me to test?
> 
> Oh, thought your previous reply was already responding to this. The 
> "other diagnostic port", 0xed. The point is not so much that it's going 
> to be a good alternate solution but to exclude it being a possible 
> solution.
> 
>> Also, I can run the timing test on my machine if you share the source
>> code so I can build it.
> 
> Thanks, would be interesting. This one:

Okay, this needs to be junked. I don't get it, but I get different results 
from an -O2 and an -O0 compile on this one.

Anyone?

Rene.

