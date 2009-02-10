Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZBJCsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZBJCsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 21:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZBJCsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 21:48:10 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:8678 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZBJCsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 21:48:09 -0500
MIME-Version: 1.0
In-Reply-To: <20090205120608.GB8799@elte.hu>
References: <20090205112414.104100700@chello.nl>
	 <20090205120608.GB8799@elte.hu>
Date: Tue, 10 Feb 2009 10:48:07 +0800
Message-ID: <d3f22a0902091848y43661118ie4ddf90e44357c46@mail.gmail.com>
Subject: Re: [PATCH 0/2] fix the itimer regression (BZ 12618)
From: Lin Ming <lin@minggr.cn>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       yanmin_zhang@linux.intel.com, seto.hidetoshi@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 8:06 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> This should hopefully address all the itimer borkage.
>
> Applied to tip:timers/urgent, thanks Peter!
>
> Yanmin: could you check hacbench_pth with latest tip/master, do
> these fixes resolve that 3% regression you reported?

hacbench_pth still has regression with 2.6.29-rc4.
Below 2 patches that fixed the regression are not merged into 2.6.29-rc4.

commit 32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Feb 5 12:24:15 2009 +0100

    signal: re-add dead task accumulation stats.

commit 4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Thu Feb 5 12:24:16 2009 +0100

    timers: split process wide cpu clocks/timers

Lin Ming
