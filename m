Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZACGht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZACGht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 01:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZACGhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 01:37:40 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:17585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZACGhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 01:37:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G9gcamAxU3TbGc9NCiEvkPE+HcELvVVUHIyXauCLab8BAKeWJqVlDOu4Th3/7sDJJ0
         YRSQ6lCR5JA9kwAObt2rydhHGMFPaWeEMD4awRVEy13YFJTKXSI9ncy0UShPtKlWnDGs
         XIRXLViR2Ym3HJloHJaMh16yDQeYI2ccDhbLM=
Message-ID: <8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
Date: Sat, 3 Jan 2009 06:37:38 +0000
From: "Ben Goodger" <goodgerster@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       linasvepstas@gmail.com, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <495F0672.6020708@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090102210430.49649261@diego-desktop> <495E7849.4030706@shaw.ca>
	 <495F0672.6020708@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/3 David Newall <davidn@davidnewall.com>:
> Robert Hancock wrote:
>> Diego Calleja wrote:
>>> How could I create a test case that reproduces what ntp does? Just add
>>> a second?
>>
>> I'd think that setting the clock to just before midnight on Dec.31 and
>> using the adjtimex syscall to set the TIME_INS state on the clock,
>> then waiting until midnight rolls around would be a reasonable test..
>
> I don't understand this idea, nor the patch for the problem.  I don't
> see why adding a leap second would impact the kernel in any way.
> Shouldn't this be a simple zoneinfo change, whereby the last two seconds
> of the year (in each timezone) both map to 31dec2008 23:59:59?  That's
> the way the change has worked in the real world.  Why would ntp or the
> kernel be involved?

Actually, the change has worked in the real world with the
introduction of a new second named 23:59:60, or else ignoring the leap
second entirely and correcting the clock (or not) later...

-- 
Benjamin Goodger

-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GCS/S/M/B d- s++:-- a18 c++$ UL>+++ P--- L++>+++ E- W+++$ N--- K? w---
O? M- V? PS+(++) PE-() Y+ PGP+ t 5? X-- R- !tv() b+++>++++ DI+++ D+ G
e>++++ h! !r*(-) y
------END GEEK CODE BLOCK------
