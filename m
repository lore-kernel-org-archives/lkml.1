Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYCKS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYCKS6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYCKS6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:58:02 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39862 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYCKS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:58:01 -0400
Message-ID: <47D6D61F.4050805@garzik.org>
Date: Tue, 11 Mar 2008 14:57:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl> <47D5D4E7.1060900@garzik.org> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 10 Mar 2008, Jeff Garzik wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
>>> Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3)

>> FWIW, I have this same problem.

> Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
> problem for you?

Nope.  I am running baadac8b10c5ac15ce3d26b68fa266c8889b163f now, and it 
still hangs on reboot or power-off.

Interestingly, if I reboot -immediately- from gdm, it succeeds.  However 
if I login to Fedora GNOME via gdm, and load my standard apps (1001 
terminals, firefox, tbird, IRC) reboot and poweroff no longer work.

My guess was always some ACPI regression.  I'll bisect today or 
tomorrow.  It is reproducible regression that appeared recently (circa 
2.6.24 or 2.6.25-rc1 I think), so I should be able to find the culprit.

	Jeff



