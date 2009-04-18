Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZDRH70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZDRH70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZDRH7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:59:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZDRH7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:59:17 -0400
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	<1239951613.23397.4107.camel@laptop>
	<alpine.DEB.1.10.0904170941020.11877@qirst.com>
	<1239977776.23397.4590.camel@laptop>
	<alpine.DEB.1.10.0904171021360.20239@qirst.com>
	<1239979901.23397.4638.camel@laptop>
	<alpine.DEB.1.10.0904171100510.21575@qirst.com>
	<20090417153520.GA29968@elte.hu>
	<alpine.DEB.1.10.0904171142050.13734@qirst.com>
	<1239985426.23397.4757.camel@laptop> <20090417164918.GK8253@elte.hu>
	<alpine.DEB.1.10.0904171335490.28603@qirst.com>
	<1239991892.23397.4905.camel@laptop>
	<alpine.DEB.1.10.0904171410540.28536@qirst.com>
	<49E90F9D.5010308@nortel.com>
Date: Sat, 18 Apr 2009 09:59:11 +0200
In-Reply-To: <49E90F9D.5010308@nortel.com> (Chris Friesen's message of "Fri, 17 Apr 2009 17:24:13 -0600")
Message-ID: <87vdp2qto0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chris Friesen" <cfriesen@nortel.com> writes:
>
> Given that we're talking about tens of usecs of duration, statistical
> sampling may not work all that well.

He could just use oprofile with a small period. The minimum period for
CPU_CLK_UNHALTED is 6000 (and it could be probably lowered by tweaking
the events) oprofile counters on x86 can be configured to only count
in ring 0 So you would get an entry every 6000 ring 0 cycles. That
should give a pretty good picture where the kernel is spending time.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
