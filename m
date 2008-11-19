Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYKSQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYKSQcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:32:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYKSQb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:31:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34487 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYKSQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:31:58 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5438"; a="13272065"
Message-ID: <49243F7C.9090109@qualcomm.com>
Date: Wed, 19 Nov 2008 08:31:56 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com> <4923731E.7010601@qualcomm.com> <20081119125135.GB20475@elte.hu>
In-Reply-To: <20081119125135.GB20475@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> What you described is almost exactly what I did in my original cpu 
>> isolation patch, which did get NAKed :). Basically I used global 
>> cpu_isolated_map and exposed 'isolated' bit, etc.
> 
> Please extend cpusets according to the plan outlined by PeterZ a few 
> months ago - that's the right place to do partitioning.

Already did. It's all in mainline. The part you quoted was just pointing out
that the original approach was not correct.

Max
