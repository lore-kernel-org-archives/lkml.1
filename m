Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbZAFFAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbZAFFAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZAFFAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:00:32 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:17793 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZAFFAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ReWXT2qCJId9VhbqjxBbTN85gLnDySVoH07qyZociaha83ofbfhHUzxXc3Cp09z20a
         ueCpU5+LRO7jySU6yIPYd1C8m3k7dKgVgQVQd5IWJxHuSkvFR9k1ZhfuH8ApN4emblbj
         MVjwu+Y8PrIMqNiWGZk0mcEQ3Fr9GIhGB1Lqc=
Message-ID: <3ae3aa420901052100q18afb1d0x19b85355a07d5dce@mail.gmail.com>
Date: Mon, 5 Jan 2009 23:00:30 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "john stultz-lkml" <johnstul.lkml@gmail.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: david@lang.hm, "Nick Andrew" <nick@nick-andrew.net>,
       "David Newall" <davidn@davidnewall.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net,
       mills@udel.edu, "Brian Haberman" <brian@innovationslab.net>,
       "Karen O'Donoghue" <karen.odonoghue@navy.mil>, ntpwg@lists.ntp.isc.org,
       zippel@linux-m68k.org
In-Reply-To: <3ae3aa420901052053m5a410671u13ecccfb7e29260c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	 <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	 <1f1b08da0901051827r57158990ic795208ba37120ad@mail.gmail.com>
	 <3ae3aa420901052053m5a410671u13ecccfb7e29260c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops.

2009/1/5 Linas Vepstas <linasvepstas@gmail.com>:
> 2009/1/5 john stultz-lkml <johnstul.lkml@gmail.com>:
>> On Mon, Jan 5, 2009 at 9:42 AM, Linas Vepstas <linasvepstas@gmail.com> wrote:
>> [snip]
>>> The long term solution would be write an RFC to extend
>>> NTP to also provide TAI information -- e.g. to add a
>>> message that indicates the current leap-second offset
>>> between UTC and TAI.
>>
>> I believe Roman has already added this ability:
>> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=153b5d054ac2d98ea0d86504884326b6777f683d;hp=9f14f669d18477fe3df071e2fa4da36c00acee8e
>
> Well, you're answering a different statment than what
> I was talking about -- I wanted to make sure that TAI
> information was available via NTP -- this has nothing
> to do with the kernel, and would be something available
> to all operating systems.
>
> Anyway -- I'm looking at the patch you reference, and
> maybe I'm being dumb -- but -- I think I see a bug.
>
> case TIME_DEL decrements TAI, but TIME_INS does
> not increment it. Instead, there's a lonely increment in
> TIME_OOP which seems wrong.  ??

Never mind. Sorry, I'm wrong, the code looks right.
Time to stop reading email, and go to bed. :-)

--linas
