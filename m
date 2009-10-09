Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbZJISx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbZJISx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbZJISx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:53:26 -0400
Received: from smtp129.mail.ukl.yahoo.com ([77.238.184.60]:23510 "HELO
	smtp129.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932844AbZJISx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:53:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ewrEyWmixum9L6XmGT9+gN3eWSkWeC0vWqZ9d6mZIRwPlgAQfiHd6KSEOQ5RWnQ6NitOYdb2I+ECd0eglwmk8BHHncCy0IJ9ss4MgfnMY0kfe18b+LKHrkrRZttiGp7NYUZIwNDaWNbXhsixDGfH35RAr9cY11epoKdPQOMot34=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: URZLtiYVM1nHFW89ORjRrYyHDtMPfZIRuV5GS4IbkGmhpy2D.YSz7QTmQwV3hPFTLLqSAX708mMlyhao_uJFNO4mibDfq6IX0aNc9QoUajpw0fI2sv5zDrzbZNTqUnP8WBlDZ.ZO.zEJKDPRahWt9ELKmd9zvOtI982cXJsWwElkz._O6rdU4fyYeJC_toSx9ZA6AXiOX_6zYRxefoEWdzDyiSkQuvA5eClu8ynJ.nTRDat3mCFme86AOuFneb9jMIbFQeR49gu7DYJWqN8-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4ACF867E.5000006@yahoo.es>
Date: Fri, 09 Oct 2009 20:52:46 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: b43: do not stack-allocate pio rx/tx header and tail buffers
References: <200910062252.17565.mb@bu3sch.de> <4ACCD765.7080604@lwfinger.net> <4ACF76F7.30406@yahoo.es> <200910092005.59916.mb@bu3sch.de>
In-Reply-To: <200910092005.59916.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
>> The reason I posted the initial patch for review was because you kind of told me [2].
>>
>> [20:06] <mb_> Anyway, I'm not going to fix this. If you need it fixed, please send patches
> 
> Yeah, but that doesn't mean that either hack is acceptable. It just means that my time is limited
> and I added this non-issue (which I still think it is) to the very bottom of my priority list.

The patch got elaborated and discussed publicly (successfully or not) by following your instructions.

>> My point here is that there's no reason for such strong words concerning the quality of the patch code. It's really not that bad for such wording.
>> I'm sure that if the patch was really crap it would have been immediately NAK'ed by you or by any sane maintainer.
> 
> It _was_ immediately NAK'ed by me. I did not know that I need to NAK
> every single new version of a patch explicitely.
> I thought NAK-ing a patch would put it into some special state that only an explicit ACK could
> take it out of.

We all sure had a communication issue here.

What you thought it was an (implicit) NAK for the _initial_ version of the patch, others took that as "fix-those-concerns-and-its-fine".
And the expressed concerns where addressed later in the merged patch, sub-optimally (not crappily).

Looking at your new "[PATCH] b43: Optimize PIO scratchbuffer usage" to address the changes introduced by the merged patch, the merged solution is not that _blatantly_ far from your solution.
The patch would have probably got there in one iteration if you have had the chance again to express your new concerns about v2.

I'm sure we can avoid this in the future by being a bit more explicit.

Thanks,
Albert

