Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYHLQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYHLQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYHLQEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:04:06 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:43331 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYHLQEF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:04:05 -0400
X-BigFish: VPS-39(z21eWz1432R1447R1805M14e1Jzzzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HWMD-01-UA6-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Date: Tue, 12 Aug 2008 11:03:54 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC60@sausexmb4.amd.com>
In-Reply-To: <200808092321.16711.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Regression] 2.6.27-rc2-git4: suspend and power off fails on Asus M3A32-MVP
Thread-Index: Acj6ZYlcwx+tdXUkSQyd8YdKJ54PtwCL2B/g
References: <200808092321.16711.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Jones" <davej@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, <kernel-testers@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Arnold, Frank" <Frank.Arnold@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 16:03:56.0888 (UTC) FILETIME=[06777D80:01C8FC95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Unfortunately, your commit 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
> ("[CPUFREQ][2/2] preregister support for powernow-k8") causes 
> a power off/
> suspend/ hibernation regression on my test box with the Asus M3A32-MVP
> mainboard (AMD 790 chipset) and the Phenom 9850 CPU.
> 
> Apparently, the patch causes a crash in a CPU hotplug 
> notifier to happen, but I'm not really sure of that, since there are a
lot of stack 
> traces resulting from it and I'm unable to capture them over a serial
console.
> 
> It is sufficient to revert commit 
> 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0 to
> make things work again.

Thanks for the clear report.  I'll look into it and try to fix it.

-Mark Langsdorf
Operating System Research Center
AMD

