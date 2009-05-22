Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZEVQso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZEVQso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbZEVQsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:48:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbZEVQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:48:36 -0400
Message-ID: <4A16D735.8090104@zytor.com>
Date: Fri, 22 May 2009 09:47:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on	several
 CPUs
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab> <4A156361.2040507@zytor.com> <20090521162638.GA10824@aftab> <4A159179.6070607@zytor.com> <20090522143918.GA22850@aftab>
In-Reply-To: <20090522143918.GA22850@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>>
>> If nothing else it might matter for boot time.  Serializing *anything*
>> across a large number of CPUs can be very expensive.
> 
> well, upon a closer look, smp_call_function_many() skips over the CPU
> it is executing on and there's currently work in that area to extend
> that API: http://marc.info/?l=linux-kernel&m=123979231511594&w=2.
> 
> However, according to Linus' comments, it looks like this would need a
> bit of work so I guess we should wait with the concurrency stuff a bit,
> no?
> 

Well, we can introduce the API now if that's where we intend it to go.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

