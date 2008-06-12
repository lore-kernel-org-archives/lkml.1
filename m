Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYFLO0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYFLO0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYFLOZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:25:57 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22753 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYFLOZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:25:56 -0400
X-BigFish: VPS-24(z297cpz98dR4015M7efV1390Mzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2CTEP-01-6JC-01
Date: Thu, 12 Jun 2008 16:24:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Message-ID: <20080612142455.GC7763@alberich.amd.com>
References: <20080610171639.551369443@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080610171639.551369443@linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2008 14:24:57.0082 (UTC) FILETIME=[16DE45A0:01C8CC98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:28:32AM -0000, Thomas Gleixner wrote:
> ...
> The following patch series implements a C1E aware idle function which
> also covers the late C1E enablement (case #3):
> ...

Great work!
>From a first glance and test it looks really good.
Just about 10 wakeups from idle on a C1E enabled box here.

Will do some deeper review and more tests later.

> The patches work fine on systems which are not affected by the dreaded
> ATI chipset timer wreckage. On those which have the problem, the box
> needs help from the keyboard to continue working.

I am currently not aware of that timer wreckage problem.
Are you referring to one of the HPET related bugzillas at Kernel Bug
Tracker?
If not, do you have a pointer to more information regarding this?
(Say, problem description and lspci -vxxx output for such a system.)


Thanks,

Andreas


