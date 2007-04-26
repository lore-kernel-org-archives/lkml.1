Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXDZHWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXDZHWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXDZHWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:22:24 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:31605 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933298AbXDZHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:22:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GEXkz/Ltj2Hiz/ZoHFfX8TsVB7wd9+zpOAR75dShNAtYhCopz87M/vTfpThFT0WBmzktzAm29l52MXXytHyuq09Rx6DzgAMfuoxT1FLefBhY9rHZrrOKN63MTqvWWGwlB1DQJKGpZ9Q93tcv7oMAe6vhiDpuHi0uORWcQgoyMik=  ;
X-YMail-OSG: MfU5UD8VM1lxxYDWdNRnxHMhs6XVvhYx38WniuO0e_ABu5RIViOpOw9.51s78UDV0Xtvw0tGvg--
Message-ID: <46305327.2000206@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:22:15 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>>Right and we need to create series of other approaches that we then label
>>>"non-hack" to replace it. 
>>
>>I don't understand? We're talking about several utterly different designs
>>to approach these problems. You don't agree that one might be better than
>>another?
> 
> 
> What I seeing is a series of approaches being put into the kernel to 
> address this issue. We already have the lumpy reclaim there. Then we talk 
> about other fixed to basic page handling in the kernel to make it better.
> Now you want yet another fs layer. All of that could be taken care of by

No I don't want to add another fs layer.

> a defrag approach with larger pages. This has been done a number of times 
> before and actually the large page approach is a textbook example on how 
> to improve performance. It goes waaaay back.

I still don't think anti fragmentation or defragmentation are a good
approach, when you consider the alternatives.

It is like Linus on the page colouring issue. That goes back a looong
way too, but that doesn't mean it is the right way to do it.


>>>The code paths can stay the same. You can switch CONFIG_LARGE pages off
>>>if you do not want it and it is as it was.
>>
>>That isn't a good reason to merge something. If you don't have numbers then
>>that just seems incredible.
> 
> 
> Dont worry you will get numbers... Just did not have time to fix the bug 
> in this one since I had to take care of something else.

OK, I would like to see them. And also discussions of things like why
we shouldn't increase PAGE_SIZE instead.

-- 
SUSE Labs, Novell Inc.
