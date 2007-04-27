Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbXD0NGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbXD0NGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXD0NGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:06:53 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33409 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755804AbXD0NGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:06:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=BTb3G1bfAm5zNMLRl8GEr0C2NQ7CUHgCQN68MuPMnFFj2TBWgI9aKm+3fvBEZQC0beHCGkZadea5HNF1PTxbWXUtmyZUU2nd6UwlVEL+Himiu5M5lb39Q04k9jMKlp+1fmIoIq76FY6Ld45EYXwcViskP08QftwJ1o6XxMet18Y=  ;
X-YMail-OSG: KscTbJ4VM1lFob7Uyy84kKAYJg4DM1aHYBObDw6h8xejognjoDdKnj5TRDaYNwigFZipW__WBw--
Message-ID: <4631F55C.2040800@yahoo.com.au>
Date: Fri, 27 Apr 2007 23:06:36 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com> <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com> <20070427003216.GM19966@holomorphy.com> <4631CECF.4030301@yahoo.com.au> <20070427125843.GO19966@holomorphy.com>
In-Reply-To: <20070427125843.GO19966@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> 
>>>I readily concede that seeks are most costly. Yet memory contiguity
>>>remains rather influential.
>>>Witness the fact that I'm now being called upon a second time to
>>>adjust the order in which mm/page_alloc.c returns pages for the
>>>sake of implicitly establishing IO contiguity (or otherwise
>>>determining why things are coming out backward now).
> 
> 
> On Fri, Apr 27, 2007 at 08:22:07PM +1000, Nick Piggin wrote:
> 
>>Just a random aside question... doesn't Oracle db do direct IO from
>>hugepages?
> 
> 
> If and when configured to use direct IO and hugepages, yes.

Sweet. I wonder if you would see a much improvement for allowing more
than 128 sglist entries, then.


> It's also
> noteworthy thar Oracle has more code than its database.

Anything noteworthy in this context, that you care to note?

-- 
SUSE Labs, Novell Inc.
