Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYI0Sa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYI0Sa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYI0SaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:30:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:14400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbYI0SaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:30:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iB+itQS3XtFNKgX0cr5t2Mf3H0Z8rl+BNU+KQySS7yT3lE9+FILXulr/geyuhdhO4f
         xkTtDKpRB0Q+RrECpFwHYT482H1IrnxWW+nLso9PStPG7c0g0a5G532fblWvHb1JBm8s
         81yTbjmr1xUBgL3L71CtqLNohAE6Le1tk+d6c=
Message-ID: <19f34abd0809271130h47cef59em759910b1cd2c920c@mail.gmail.com>
Date: Sat, 27 Sep 2008 20:30:16 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: Swap on loop device on tmpfs locks up machine
Cc: "David Newall" <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
In-Reply-To: <48DE6F93.9030002@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
	 <48DE2BF7.3060905@davidnewall.com> <48DE6F93.9030002@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 7:38 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> David Newall wrote:
>>
>> Vegard Nossum wrote:
>>>
>>> It turns out that swap over loop device on tmpfs will lock up the
>>> machine.
>>
>> Doesn't tmpfs use otherwise-free virtual memory?  I expect the machine
>> would lock up if you put swap (i.e. additional virtual memory) on such a
>> device.
>
> To reinstate the paragraph from the O.P. you snipped:
>>> I'm not sure it's really a very good idea to do this in the first
>>> place, but should something give a warning or prevent a user from
>>> doing it?
>
> I think you are both right, it is a bad thing to do, it does seem to lock
> up, and something should prevent a user from doing that. But it may be
> easier to fix the lockup than get the "prevent" right, there appears to be a
> loop there.
>
> Just a simple questions to the O.P.: what were you thinking?!! Or was this a
> test just to see what would happen?

Just playing with the kernel :-)

Sometimes the "insane" things to do will turn up real errors in the
code. This one is in the borderlands, but I thought it wouldn't hurt
to post the results in either case.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
