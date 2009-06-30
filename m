Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbZF3Xgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbZF3Xgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZF3XgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:36:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbZF3XgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:36:16 -0400
Message-ID: <4A4AA0ED.2020304@zytor.com>
Date: Tue, 30 Jun 2009 16:34:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, andi@firstfloor.org,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and	improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090630233106.GB28830@elte.hu>
In-Reply-To: <20090630233106.GB28830@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Hello, Christoph.
>>
>> Christoph Lameter wrote:
> 
>>> I looked at allocating for online cpus only a couple of years 
>>> back but at that per cpu state was kept for offlined cpus in per 
>>> cpu areas. There are numerous assumptions in per cpu handling 
>>> all over the kernel that a percpu area is always available.
>> The plan is to allocate and keep percpu areas for cpus which have 
>> ever been up.  There'll be no taking down of percpu areas.  
>> Conversion from possible to has_ever_been_up should be much easier 
>> than possible -> online.  State keeping will work fine too.
> 
> That sounds like a very sane plan.
> 
> 	Ingo

Yes, percpu area dynamic *de*-allocation would almost certainly be a
nightmare.

	-hpa

