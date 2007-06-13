Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXFMDga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXFMDga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXFMDgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:36:21 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:22183 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752611AbXFMDgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:36:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VSilKiDMk1Kn8yUYq3uyh/RxYOAZeG1Vh02hq/pRUY66O5WQRKBBqX7surzsfsUC58ypg1Yya7J/jY27FrW/zR8Q7WYE6tZWKf6oQCZIINC6KxJKrFlnrLO8J9cXrN2yjPRHcKR2xyw+8ciSg3N/heiU3LJG3HBNna6vCU2OvDA=  ;
X-YMail-OSG: WoM2b1AVM1nkonLs1IiJEYG1GwGeSOsvcTCvwx0d2KaRKazFLdRm1gF4DSPSQX7taO7rkHcYJQ--
Message-ID: <466F6630.2050207@yahoo.com.au>
Date: Wed, 13 Jun 2007 13:36:16 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: ck@vds.kolivas.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: kernel scedular
References: <466B45D3.3020104@gmail.com> <alpine.LFD.0.98.0706091731020.20321@woody.linux-foundation.org> (sfid-20070612_171643_519639_3A5C9A70) <200706121925.02286.Martin@lichtvoll.de>
In-Reply-To: <200706121925.02286.Martin@lichtvoll.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Sonntag 10 Juni 2007 schrieb Linus Torvalds:
> 
> Hi Linus!
> 
> 
>>Ehh.. It was tested extensively by lots of people. It was in -mm for a
>>while, and yes, there have been tons of people testing both. I've
>>followed it, and it seems fair to say that yes, Ingo took a lot of
>>ideas from SD, but CFS seems to have gotten more people involved, and
>>we had several people compare the two, and CFS was generally better.
> 
> 
> Well actually I did not see that general result yet. I have seen quite 
> some testings and quite some reports on the ck patch mailinglist also 
> where in favor of SD. If it matters I will collect those, but I think 
> Ingo already did include most of them in his summary.

I'd just like to say that last time I tested CFS it was very slow
on context switching. I don't know if this has been improved, but I
think it should be.

I'm not talking about context switching with heaps of tasks, but
about lmbench 2-task ping pongs and such.

Also it used pretty small timeslices to achieve interactivity, which
didn't seem like a good idea. I wonder if that's been fixed?

-- 
SUSE Labs, Novell Inc.
