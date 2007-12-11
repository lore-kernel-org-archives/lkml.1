Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbXLKRBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbXLKRBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXLKRBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:01:18 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:51871 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbXLKRBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:01:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 18.85.9.165
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/W9/XJD1PN78RY0io+f7Cj
Message-ID: <475EC246.10205@reed.com>
Date: Tue, 11 Dec 2007 12:00:54 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl>
In-Reply-To: <475EBFBA.6090301@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which port do you want me to test?  Also, I can run the timing test on 
my machine if you share the source code so I can build it.

Rene Herman wrote:
> On 11-12-07 17:30, Andi Kleen wrote:
>
>> Anyways it looks like the discussion here is going in a
>> a loop. I had hoped David would post his test results with
>> another port so that we know for sure that the bus aborts (and not 
>> port 80) is the problem on his box. But it looks like
>> he doesn't want to do this. Still removing the bus aborts
>> is probably the correct way to go forward.
>
> Yes, I do also still want to know that. David (Reed)?
>
>> Only needs a patch now. If nobody beats me to it i'll
>> add one later to my tree.
>
> Pavel Machek already posted one. His udelay(8) wants to be less -- 1 
> or "to be safe" perhaps 2.
>
> http://lkml.org/lkml/2007/12/9/131
>
> Rene.
>
