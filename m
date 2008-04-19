Return-Path: <linux-kernel-owner+w=401wt.eu-S1762210AbYDSQnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762210AbYDSQnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762028AbYDSQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:42:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:63016 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbYDSQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=GGLMmqKNW9wmyJuIM8MHgFjey0LrpkY5DaDTwu3WWUCTFdaaXHXvT2WsRx2sQG6JTh5o0Hw4x8SqqhjA9SVSTSwjMNOeangzNavEnWn2wY/nwOrUakj7HLKOj647J9ZRTtey5e37XkW0ARneUUbHuIRGnCFn/T3chEoNMvCmOmg=
Message-ID: <480A20F8.6020802@tuffmail.co.uk>
Date: Sat, 19 Apr 2008 17:42:32 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: Self-snapshotting in Linux
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it> <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com> <20080416111237.GA32432@atrey.karlin.mff.cuni.cz> <48060436.6030707@tuffmail.co.uk> <20080417093235.GB7314@elf.ucw.cz>
In-Reply-To: <20080417093235.GB7314@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-04-16 14:50:46, Alan Jenkins wrote:
>   
>> Pavel Machek wrote:
>>     
>>>> I guess there is the hardware / drivers issue.  I would like to claim
>>>> I've found hibernation to be reliable but unfortunately that's not
>>>> 100% true.
>>>>     
>>>>         
>>> So debug it, it is open source after all. Or at least file a bugs.
>>>   
>>>       
>> I definitely want to debug it; I love hibernating.  It's a regression and 
>> it'll affect my distro kernel once I upgrade to Ubuntu Hardy.
>>
>> <http://bugzilla.kernel.org/show_bug.cgi?id=10196> "Backtraces during 
>> hibernate / resume".
>>
>> I posted the backtraces but nobody could tell me what they were - they 
>> don't actually say whether they're OOPs or BUGs etc.  They might be 
>> softlockups - some times I got softlockup warnings, though thats not in the 
>> log I posted.
>>     
>
> Not sure what that is, I never seen that before.
>
> Can you try vanilla 2.6.25-rc9 or something?
>   
I've just retested with 2.6.25.  I reproduced the hang that happens
after (otherwise successful) hibernation.  After a second hibernation &
resume I reproduced the mysterious call-traces.

I posted this information, a full system log (including 2 hibernation
cycles and the calltraces), and the kernel config to the bugzilla entry.

This was in response to Rafael's request on the bugzilla.  So I expect
someone will look at it anyway, but I thought I should copy you on this.

Thanks,

Alan
