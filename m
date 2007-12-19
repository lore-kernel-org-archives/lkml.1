Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbXLSPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbXLSPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbXLSPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:21:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:42728 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbXLSPVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:21:08 -0500
Message-ID: <476936E2.9010902@qumranet.com>
Date: Wed, 19 Dec 2007 17:21:06 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] Guest kernel hangs in smp kvm for older kernels	prior
 to tsc sync cleanup
References: <47680173.6060606@qumranet.com> <20071218221930.GA26109@elte.hu> <4768BB43.1000609@qumranet.com> <4768FE27.7020305@qumranet.com> <47690304.1090903@qumranet.com> <20071219140624.GF21282@elte.hu> <47693054.20501@qumranet.com> <20071219150938.GA15267@elte.hu>
In-Reply-To: <20071219150938.GA15267@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> try this test perhaps in an SMP guest:
>
>  http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
>
> you can ignore TSC warps - but no GTOD or CLOCK warps should occur.
>
>   

On a broken guest kernel, I see gtod and clock warps.  On a good guest 
kernel, I do not, presumably because the tsc clocksource is marked as 
unstable.

I see tsc warps on both.  8 threads on 4 cpus.

-- 
error compiling committee.c: too many arguments to function

