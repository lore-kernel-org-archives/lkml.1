Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0BVNbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 08:31:15 -0500
Received: from borg.medozas.de ([188.40.89.202]:60085 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0BVNbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 08:31:14 -0500
Date: Mon, 22 Feb 2010 14:31:09 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: tools/perf: libraries must come after objects
In-Reply-To: <20100222105025.GA25661@elte.hu>
Message-ID: <alpine.LSU.2.01.1002221430440.23762@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr> <20100222105025.GA25661@elte.hu>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2010-02-22 11:50, Ingo Molnar wrote:
>> 
>> tools/perf: libraries must come after objects
>> 
>> Link order matters, especially now since distributions are
>> using -Wl,--as-needed.
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>>  tools/perf/Makefile |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>
>FYI, this patch doesnt apply to the latest version of perf:
>
> patching file tools/perf/Makefile
> Hunk #1 FAILED at 201.
> Hunk #2 FAILED at 421.
> Hunk #3 FAILED at 432.
> Hunk #4 succeeded at 770 (offset 93 lines).
> 3 out of 4 hunks FAILED -- rejects in file tools/perf/Makefile
>
>you can find the devel tree at:
>
>  http://people.redhat.com/mingo/tip.git/README

Do happen to have that as a faster git:// too?
