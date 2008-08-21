Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYHUQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYHUQra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYHUQrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:47:22 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50991 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYHUQrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:47:21 -0400
X-BigFish: VPS-50(zz1432R98dR936eQ62a3L1805M936fQ9371Pzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5YMMI-01-XUD-01
Date: Thu, 21 Aug 2008 18:46:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Message-ID: <20080821164649.GC2453@erda.amd.com>
References: <48AD82D5.76E4.0078.0@novell.com> <20080821132952.GD13011@erda.amd.com> <86802c440808210925g401d62e4td84a43c223571327@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808210925g401d62e4td84a43c223571327@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Aug 2008 16:47:11.0124 (UTC) FILETIME=[8E783D40:01C903AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.08 09:25:37, Yinghai Lu wrote:
> On Thu, Aug 21, 2008 at 6:29 AM, Robert Richter <robert.richter@amd.com> wrote:
> > On 21.08.08 13:59:33, Jan Beulich wrote:
> >> Even worse - this would even try to access the MSR on non-AMD CPUs
> >> (currently probably prevented just by the fact that only AMD ones use
> >> family values of 0x10 or higher).
> >
> > Ups, really worse. Code was AMD specific before and became
> > generic. Will fix this.
> >
> 
> it seems you didn't address the concern about hotplug as you promised
> 
> http://lkml.org/lkml/2008/6/13/151

Yinghai, I know. You made a comment on this in reply to the patch and
this is still an open issue. Really, will fix this. :-)

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

