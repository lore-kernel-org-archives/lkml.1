Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYKMUVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYKMUVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYKMUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:21:35 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:45196 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYKMUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:21:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Q2SzmePQ+cxW/Ru0ff8XkDu7WDxv8zojTN4mtcuyRRxCS6+Ie8oDSIsqPLN04Ktr;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <491C8C48.3030602@earthlink.net>
Date: Thu, 13 Nov 2008 15:21:28 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Pavel Roskin <proski@gnu.org>,
       Michael Renzmann <mrenzmann@madwifi-project.org>,
       madwifi-project@venema.h4ckr.net,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [madwifi-project] [RFC] Closing the project
References: <2576.194.45.26.221.1226491274.squirrel@webmail.madwifi.org>	 <1226511194.9952.38.camel@dv>	 <43e72e890811121224w4fc53e1s29080a42111186e9@mail.gmail.com>	 <1226547092.11785.49.camel@dv> <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
In-Reply-To: <43e72e890811131142p3f72c964t802d424b0ddb3456@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7926c0e700161bbe3fe7eeb876fae90c9a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Wed, Nov 12, 2008 at 7:31 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Wed, 2008-11-12 at 12:24 -0800, Luis R. Rodriguez wrote:
>>
>>> Those who are interested in this should work on it if no one else is,
>>> just take it and go. Bureaucracy gets in the way here IMHO.
>> It's not about bureaucracy.  I need help with porting the code from one
>> branch to another.  In particular, with fixing SMP locking issues in the
>> 0.9.4 branch.  The trunk doesn't have those issues.
> 
> If you are not getting help its because there is a lack of interest
> from developers. I expected this once ath5k got upstream and once more
> documentation was available.
> 
>>> Distributions will soon prefer ath5k over MadWifi. At that point
>>> MadWifi becomes a relic. Its surely good to keep MadWifi code
>>> somewhere for reference, or maybe for the last few devices maybe not
>>> yet supported, but any other effort put into seems like fruitless
>>> effort spent IMHO.
>> As far as I know, we don't have DFS in mac80211.  In fact, the AP mode
>> in mac80211 has just been enabled.
> 
> Right, more notes on this below.
> 
>>> I don't have experience with bounties but I do know I get random
>>> requests to support one thing or another for money. I am going to be
>>> redirecting these request more to bounties put up for upstream
>>> development. I know people will work on things anyway but what I want
>>> to try to do is get monetary support one way or another to those
>>> working upstream.
>> OK, let's consider it on the case-by-case basis.
> 
> Well I'm just going to direct people towards bounties myself for
> upstream work. That's the advice I will be giving personally. But I do
> think it would be good for the project to also reward upstream work
> too, wasn't that the whole point behind the project?
> 
>>> I'd like to encourage the money left for the project for similar
>>> purposes. Reward upstream development.
>> Maybe we could have a bounty for DFS implementation in mac80211?  Just
>> to try how it would work.  I also this that there should be a strong
>> moral incentive for the winner.  Not just a name in the log, but a web
>> page about the winner on kernel.org.  This way, we would attract people
>> striving to improve their resumes, not just get extra money.
> 
> We will be working on DFS on mac80211, I will start first with STA
> DFS. Also expect a lot of work from us on AP support.
> 
>>> I think MadWifi has become a big bureaucratic entity and this large
>>> bureaucracy is simply not needed.
>> I agree that we have a lot of documentation that is becoming irrelevant.
>> I prefer to keep documentation to the minimum, as it stimulates
>> developers to write software that just works, without lengthy
>> instructions.
>>
>> But the bug tracking system has some important information that we still
>> may need.
>>
>> I think the biggest impediment to MadWifi development was not
>> bureaucracy.  It was the non-free HAL.
> 
> Not really, even with an alternative people are still used to coding
> with it and find it easier to commit into an svn repository than
> submit  patches upstream. Maybe our process is move involved but there
> its also why Linux code has a certain quality in it. We tend to frown
> upon crap. If MadWifi ever were to touch Linux it would be tainted
> with CRAP.
> 
>> Many bugs are too hard or
>> impossible to solve without having access to HAL.  As the easy bugs get
>> fixed, the ratio of HAL-related bugs grows further.
>>
>> We have HAL sources, but it's not the sources we could use in Madwifi
>> without losing some functionality.  Sure enough, the HAL sources could
>> help with some issues.  But it's still impossible to put debug
>> statements into the HAL uses in MadWifi.
>>
>> I'm thinking of having "MadWifi free edition" with limited hardware
>> support specifically to address the issue of "debuggability".  Also,
>> some users may free code plus MadWifi features.
> 
> I really think this is good for those interested and I respect it but
> I am going to be very very honest here: this is a complete fucking
> waste of time. People, MadWifi is dead, stop trying to keep it a live
> by injecting its heart with adrenaline, it won't work, just pull the
> plug already. If any feature is missing I think it would be more
> productive to identify it and point it out and those interested in
> upstream work will add it.
> 
>>  Some users may want
>> support for exotic CPUs not supported by any non-free HAL.
> 
> For that you can use the Linux kernel which will get you support on
> the largest number of CPUs possible.
> 
>>>  We wanted free drivers, we have them
>>> now, we have opened up the HAL and have even opened up more drivers
>>> and continue to do so. What I find useful from MadWifi from an
>>> upstream perspective is the mailing lists and a central place for
>>> people to get information/news regarding Atheros devices supported
>>> upstream but I guess we can just keep this in the wireless wiki.
>> I agree that it's better to start anew with the documentation for the
>> free drivers.
>>
>>> Mailing lists are pretty useful though.
>> Yes.
>>
>>> I agree there is some useful information present but a lot of it is
>>> purely historical and I don't think much resources is needed to keep
>>> that around. I suspect distributions will start preferring ath5k over
>>> MadWifi around December if not already so I'm indifferent in closing
>>> MadWifi. In my head MadWifi is dead already though and would recommend
>>> we only promise users it will be in maintenance mode, meaning the
>>> MadWifi driver will only get submitted bug fixes and security fixes.
>> I agree with you.  We should fix the code already in MadWifi branches.
>> It means we should not be _closing_ the project now.
> 
> Just my advice: let MadWifi die already, stop wasting your time.
Yeah but ath5k doesn't work on my zyxel ar5212 based wireless card only
madwifi works!
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


