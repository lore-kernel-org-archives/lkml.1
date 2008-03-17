Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbYCQTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbYCQTWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbYCQTUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:20:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59386 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756229AbYCQTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:20:44 -0400
Message-ID: <47DEC473.8070404@garzik.org>
Date: Mon, 17 Mar 2008 15:20:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl>
In-Reply-To: <200803112341.42517.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday, 11 of March 2008, Jeff Garzik wrote:
>> Linus Torvalds wrote:
>>> On Mon, 10 Mar 2008, Jeff Garzik wrote:
>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
>>>>> Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3)
>>>> FWIW, I have this same problem.
>>> Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
>>> problem for you?
>> Nope.  I am running baadac8b10c5ac15ce3d26b68fa266c8889b163f now, and it 
>> still hangs on reboot or power-off.
>>
>> Interestingly, if I reboot -immediately- from gdm, it succeeds.  However 
>> if I login to Fedora GNOME via gdm, and load my standard apps (1001 
>> terminals, firefox, tbird, IRC) reboot and poweroff no longer work.
>>
>> My guess was always some ACPI regression.  I'll bisect today or 
>> tomorrow.  It is reproducible regression that appeared recently (circa 
>> 2.6.24 or 2.6.25-rc1 I think), so I should be able to find the culprit.


Well, after going through several kernel versions (back to 2.6.19 so 
far), this machine continues to have reboot problems.  I'm going to 
back-burner this, as it is looking more like a hardware or BIOS problem 
that cropped up recently.

	Jeff




