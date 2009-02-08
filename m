Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZBHEfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZBHEfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 23:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZBHEfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 23:35:05 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:38559 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZBHEfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 23:35:04 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud (timekeeping_suspended)
References: <87prihcepl.fsf@burly.wgtn.ondioline.org>
	<200901211713.39630.rjw@sisk.pl>
	<87k58nda87.fsf@burly.wgtn.ondioline.org>
Date: Sun, 08 Feb 2009 17:35:02 +1300
In-Reply-To: <87k58nda87.fsf@burly.wgtn.ondioline.org> (Paul Collins's message
	of "Thu, 22 Jan 2009 21:19:04 +1300")
Message-ID: <874oz5pmvd.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins <paul@burly.ondioline.org> writes:

> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> On Wednesday 21 January 2009, Paul Collins wrote:
>>> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
>>> suspend or resume -- it's hard to tell.  (The suspend message is
>>> timestamped in syslog with the time I resumed, so I guess it was
>>> buffered along with the subsequent "Badness" messages.)
>>
>> Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
>> problem for you.
>
> It does not fix the problem.

I'm also getting this warning since 2.6.28.1, which incorporated commit
1c5745aa380efb6417b5681104b007c8612fb496 ("sched_clock: prevent
scd->clock from moving backwards, take #2") as commit
e268dcdd404f4558cdd24c8ecede3e064df8fa33, this being the patch that
introduced the WARN_ON(timekeeping_suspended) check.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
