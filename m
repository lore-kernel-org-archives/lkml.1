Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYFXRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYFXRQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYFXRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:16:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:11831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYFXRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=lpUyYicb7fEcXJWOdbisTe9O/8jEHognhhaZyU2c+MZ5+51qe26HoG4388kwFaiPpV
         f2hTiZwXaljfK4UfHATHTV9Dn3sWZccKsqxeBfFqbCDhnDpOr8PW8oyBwMilx/NUgqPx
         CYZVF1dI0BtrnzucGxZVWnh2SbPrzswCwFkqc=
Message-ID: <2c0942db0806241016o3be1dae8i433da13697c4531c@mail.gmail.com>
Date: Tue, 24 Jun 2008 10:16:14 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: stuck tcp connections 2.6.26-rc7
Cc: "Didier Raboud" <didier@raboud.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <dd18b0c30806231845s1cc6151coc2a4f26ed3521500@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806221109t2ff73f9ai52f6716748648a79@mail.gmail.com>
	 <20080622205927.301501e7.akpm@linux-foundation.org>
	 <dd18b0c30806230013x5446991bi9eba7623ffaae131@mail.gmail.com>
	 <g3ol3u$li2$1@ger.gmane.org>
	 <dd18b0c30806231845s1cc6151coc2a4f26ed3521500@mail.gmail.com>
X-Google-Sender-Auth: cb463ff2df8f00a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/23 Justin Mattock <justinmattock@gmail.com>:
> On Mon, Jun 23, 2008 at 5:04 PM, Didier Raboud <didier@raboud.com> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Justin Mattock wrote:
>>
>>> On Mon, Jun 23, 2008 at 3:59 AM, Andrew Morton
>>> <akpm@linux-foundation.org> wrote:
>>>> On Sun, 22 Jun 2008 18:09:16 +0000 "Justin Mattock"
>>>> <justinmattock@gmail.com> wrote:
>>>>
>>>>> Hello; I too am experiencing internet connectivity problems, for  a
>>>>> while I thought
>>>>> It was due to low bandwidth(or being ddos attacked) but yesterday I
>>>>> noticed with watch netstat -ntu
>>>>> send-Q was stuck on a number; the connection would not go to TIME_WAIT
>>>>> resulting in music to pause, and t.v. to freeze.
>>>>> In my experiences running xmms streaming music is fine, no problems,
>>>>> but as soon as
>>>>> you watch something with flash player the stream start's getting
>>>>> really bad. In the past with older kernel's
>>>>> I usually can watch t.v.(with flash) and stream music at the same time
>>>>> without any trouble.
>>>>> lately I've been Running the kernel in No forced Preemption with a
>>>>> time frequency at 100. having the kernel set in this mode really shows
>>>>> the connection problems, but if I change the preemption to another,
>>>>> and bump up the timer frequency the poor internet connection is not as
>>>>> bad(or stuck tcp) but still prevalent. more pops in the music, and
>>>>> sudden internet loss for around five seconds, then goes back
>>>>> So from over here streaming music has no problems from what I can see,
>>>>> but as soon as I watch media, it becomes a mess.
>>>>
>>>> (cc netdev)
>>>>
>>>
>>>
>>> Cool, Thanks for sending the cc
>>> regards;
>>
>> Hi,
>>
>> I get something like a similar bug: when pinging my local gateway, I loose
>> packets (over wifi (iwl3945) ). Before the update to 2.6.26-rc7 (Debian), I
>> had no such issues (which makes Internet browsing working but weirdly).
>>
>> I can't know for sure that my bug is related to the above, but suppose so.
>> Please ask for details !
>>
>> Regards,
>>
>> Didier Raboud
>> - --
>
> Cool;(cool as in I'm not the only one,not cool for sh*%y internet connections)
> there is something definitely happening with the tcp connection.,
> After looking more at the situation
> I get a good connection when just streaming music, but as soon as I
> watch with flash or even search through firefox
> I'm getting a dead period of no internet, and then a few seconds later
> no problems.Almost as if some timer in the code is missing something
> or not firing off at the right time.
> At this point I'm still uncertain with what is happening.
> regards;

If you leave a ping running as root to your local gateway from a
console ( nice -n -10 ping -i 0.5 192.168.1.1
 or whichever ip ), does it show dropouts?
