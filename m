Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0BUOGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:06:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751863Ab0BUOGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:06:54 -0500
Date: Sun, 21 Feb 2010 14:09:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86, irq: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR
 instead of 0x1f
Message-ID: <20100221140938.7aaab70d@lxorguk.ukuu.org.uk>
In-Reply-To: <4B80C699.1030302@zytor.com>
References: <20100114002118.436172066@sbs-t61.sc.intel.com>
	<20100114002118.521826763@sbs-t61.sc.intel.com>
	<alpine.LFD.2.00.1001240545180.13034@eddie.linux-mips.org>
	<4B5C00EB.3000208@zytor.com>
	<alpine.LFD.2.00.1001310705280.31764@eddie.linux-mips.org>
	<1265059497.2802.178.camel@sbs-t61.sc.intel.com>
	<4B674C82.9050703@zytor.com>
	<alpine.LFD.2.00.1002210438220.1146@eddie.linux-mips.org>
	<4B80C699.1030302@zytor.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Either way, this doesn't exactly sound too bad.  A bigger question is if
> we want to do this globally or end up having different vector
> assignments for these oddball CPUs.  Testing it, too, will be almost
> impossible...

If you panic it won't get tested. If its done (even as 'experimental' then
it'll either get tested or not matter). They also have relatively few IRQ
sources by modern standards so there isn't a lot to map.

The bigger problem with the old processors is that some Pentium era SMP
boards actually get material numbers of repeated interrupts where one IPI
arrives twice on another CPU. That's something present in a lot of the
later chips (pre P4 I believe but don't quote me on that) but very
unusual to observe except on a few specific boards (eg the BP6))


Alan
