Return-Path: <linux-kernel-owner+w=401wt.eu-S1751729AbYAPRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbYAPRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYAPReZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:34:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:29991 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYAPReY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MnSUTFjRilqqEop/TyOSRr3f6mwHxQMqDHpq+bzm+wK/wBLukryHL3NXQq+lZD1+o+79dgZlwT+TWIEgxeOVVGSROCSV385GwrwurO8hZbdop8nHY1SSDqdT3RJL/oDiHNE71uH1Z3VgtFCwrXGQbb6757DK08qXx1WJ6Cse1gw=
Message-ID: <cf3edd8d0801160934u2e39110dv2ccc98081e983b25@mail.gmail.com>
Date: Wed, 16 Jan 2008 17:34:22 +0000
From: "Colin Fowler" <elethiomel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive benchmark on 8 Core Xeon
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080115220641.GC2665@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com>
	 <20080114185520.GA26540@elte.hu>
	 <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com>
	 <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com>
	 <20080115220641.GC2665@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> there are a handful of 'scheduler feature bits' in
> /proc/sys/kernel/sched_features:
>
> enum {
>         SCHED_FEAT_NEW_FAIR_SLEEPERS    = 1,
>         SCHED_FEAT_WAKEUP_PREEMPT       = 2,
>         SCHED_FEAT_START_DEBIT          = 4,
>         SCHED_FEAT_TREE_AVG             = 8,
>         SCHED_FEAT_APPROX_AVG           = 16,
> };
>

Toggling SCHED_FEAT_NEW_FAIR_SLEEPERS to 0 or
SCHED_FEAT_WAKEUP_PREEMPT to 0 gives me results more inline with my
2.6.22 results. Toggling them both to 0 gives me slightly better
results than 2.6.22!

>   /sys/devices/system/cpu/sched_mc_power_savings
>
> does that change the results?
>

no measurable difference on this toggle that I can see.
