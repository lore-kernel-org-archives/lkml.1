Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbXD0Jqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbXD0Jqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0Jqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:46:44 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:46348 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755538AbXD0Jqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:46:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=bDKDjPIqbdazuMtG75hCaK2EUVXxFWKEhSq+GVqJA7Vwx+iddI1TeKytpjwFdvfvBbNdUx2zm8QG2oVWaeBlNyXNwA2tUWHgptwsVrWFbJw+gS4TALgnuP95MBwzhTna5yFhKAXWhj/jo26AwE1hELix8/PB/QJ7NVsetKm0nvA=  ;
X-YMail-OSG: YPBHPfQVM1mzx.FiraV3e8D31XYv77uNcQB6jcAirlxrwmIIhviNKFifj1KJ1eH7q_cC.CO8Cg--
Message-ID: <4631C674.9040506@yahoo.com.au>
Date: Fri, 27 Apr 2007 19:46:28 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <20070426135033.GU65285596@melbourne.sgi.com> <4630C776.9000804@yahoo.com.au> <20070426155840.GU31925@holomorphy.com>
In-Reply-To: <20070426155840.GU31925@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> 
>>Or good grounds to increase the sg limit and push for io controller
>>manufacturers to do the same. If we have a hack in the kernel that
>>mostly works, they won't.
> 
> 
> On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> 
>>Page colouring was always rejected, and lots of people who knew
>>better got upset because it was the only way the hardware would go
>>fast...
> 
> 
> Yes, stunning wisdom there. Reject the speedups.

Yeah, that's how lots of people felt. But there is a good argument
to do just that.


> On Fri, Apr 27, 2007 at 01:38:30AM +1000, Nick Piggin wrote:
> 
>>You could put it that way. Or that it is wrong because of the
>>fragmenatation problem. Realise that it is somewhat fundamental
>>considering that it is basically an unsolvable problem with our
>>current kernel assumptions of unconstrained kernel allocations and
>>a 1:1 kernel mapping.
> 
> 
> Depends on what you consider a solution. A broadly used criterion is
> that improves performance significantly in important usage cases.

My criterion is that you are not suddenly unable to access your
filesystem because you cannot allocate a higher order page.

-- 
SUSE Labs, Novell Inc.
