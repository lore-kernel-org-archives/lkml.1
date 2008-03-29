Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbYC2XoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbYC2XoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 19:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYC2XoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 19:44:11 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40923 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYC2XoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 19:44:10 -0400
Date: Sun, 30 Mar 2008 05:13:58 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Richard Jonsson <richie@coderworld.net>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Keyboard weirdness: keys get stuck
Message-ID: <20080329234358.GA28667@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <47EEA097.5000701@coderworld.net> <47EEC51C.2060806@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EEC51C.2060806@coderworld.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 11:39:24PM +0100, Richard Jonsson wrote:
> Richard Jonsson skrev:
>> With 2.6.25-rc6-git-something I have experienced stuck keys. When typing a 
>>  sentence a character repeats aboooooooout 10 times, or as 'about' above 
>> ;). I tested with a new kernel today, 2.6.25-rc7-git-something and the 
>> problem is still present.
>>
>> With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel 
>> in between.
>>
>> As a side note, timestamps gets mixed up in dmesg output in a 1-2 second 
>> span. Maybe related?
>>
>> This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want 
>> configuration details or testing to be done.
>>
>
> I should add that while watching a movie I noticed that video stutters 
> every now and then, on an irregular basis. It lasts for approx a second 
> each time.

Can you check if you have CONFIG_GROUP_SCHED enabled? If so, can you
disable and test?

Thanks,
-- 
regards,
Dhaval
