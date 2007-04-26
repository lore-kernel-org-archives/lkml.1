Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbXDZHsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbXDZHsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXDZHsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:48:22 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:32890 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933307AbXDZHsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:48:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0XNV7Djp1aZ4oVtNlgdzRezAoejORroT257mo3Ui0Cj/ce/+oApRgb1R8kzRG+0wmzNP18jJ5wD+l2/NZTaGU5qoXLa+KMkKRPtsGW3bfz5cmGa/jpgkbaZ/8SPegWxR2hSZeCVJwrRKiKFZD0rS+DYafll21Y+NM3j9kJur7rk=  ;
X-YMail-OSG: gD2L2Z0VM1kcwCdDxnb_JaA0CrticZJXgo58ia55W8gmt_gUQ4U6m_mahEZkFd4gXS2I5hcayQ--
Message-ID: <4630593C.8070905@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:48:12 +1000
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
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>No I don't want to add another fs layer.
> 
> 
> Well maybe you could explain what you want. Preferably without redefining 
> the established terms?

Support for larger buffers than page cache pages.


>>I still don't think anti fragmentation or defragmentation are a good
>>approach, when you consider the alternatives.
> 
> 
> I have not heard of any alternatives in this discussion here. Just the old 
> line of lets tune the VM here and there and hope it lasts a while longer.

I didn't realise that one was even in the running. How can you "tune" the
VM to handle bigger block sizes?


>>OK, I would like to see them. And also discussions of things like why
>>we shouldn't increase PAGE_SIZE instead.
> 
> 
> Because 4k is a good page size that is bound to the binary format? Frankly 
> there is no point in having my text files in large page sizes. However, 
> when I read a dvd then I may want to transfer 64k chunks or when use my 
> flash drive I may want to transfer 128k chunks. And yes if a scientific 
> application needs to do data dump then it should be able to use very high 
> page sizes (megabytes, gigabytes) to be able to continue its work while 
> the huge dumps runs at full I/O speed ...

So block size > page cache size... also, you should obviously be using
hardware that is tuned to work well with 4K pages, because surely there
is lots of that around.

-- 
SUSE Labs, Novell Inc.
