Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYCLTLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYCLTLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYCLTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:11:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44438 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYCLTLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:11:16 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5250"; a="1064715"
Message-ID: <47D82AD2.1070108@qualcomm.com>
Date: Wed, 12 Mar 2008 12:11:14 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
References: <47D73086.2030008@qualcomm.com>	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>	<47D7411E.1000009@qualcomm.com>	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>	<47D74595.4080100@qualcomm.com>	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>	<20080311235939.1ebee8e3.pj@sgi.com>	<47D81FE1.6030205@qualcomm.com> <20080312135746.89456f2a.pj@sgi.com>
In-Reply-To: <20080312135746.89456f2a.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max K wrote:
>> How is that any different from tasks ? Exact same example right back at you.
>> Suppose I have a task that needs to run in A and B but not C.
> 
> Can't happen.
Of course it can. See below.

> Each task belongs to exactly one cpuset, no exceptions.
Sure. Same for irqs.

> That's why you can't "treat irqs just like tasks".
Sure you can.

I was talking about running on the _cpus_ that belong to the "sets A and B but 
not C" and not that a task must belong to more than one cpuset. Unless I 
misinterpreted your example you were talking about exact same thing. In other 
words that an irq needs to assigned to the _cpus_ in the sets A and B but not C.
Makes sense ?

Max


