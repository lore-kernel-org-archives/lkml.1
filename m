Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXDZHpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXDZHpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXDZHpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:45:36 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:39901 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933470AbXDZHpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:45:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=X4saDq8S9xU6sktUPyohIK/aIEO6IPF91BHLJNKkU9AZ9MXf+DaAr6B3tcf7a8DlAaOHarZ0aDUh9UlqcNPBv1VcOVbt34N+7wjzfYIeA2rDr0Lq7R7CEIxsUvzbm49ujixfvlUlbpNGTGy8pNH3mCYQMtKdK8BlJvpisJQ0bMM=  ;
X-YMail-OSG: 5IUAJScVM1lLHdlRGD7cBXXQ.vY2J1hjimdqNB4me0Nht17O
Message-ID: <46305894.3050403@yahoo.com.au>
Date: Thu, 26 Apr 2007 17:45:24 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <20070426070454.GF32602149@melbourne.sgi.com> <46304FAF.7020700@yahoo.com.au> <Pine.LNX.4.64.0704260011140.30731@schroedinger.engr.sgi.com> <46305222.60502@yahoo.com.au> <Pine.LNX.4.64.0704260022570.31003@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704260022570.31003@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 26 Apr 2007, Nick Piggin wrote:
> 
> 
>>But I maintain that the end result is better than the fragmentation
>>based approach. A lot of people don't actually want a bigger page
>>cache size, because they want efficient internal fragmentation as
>>well, so your radix-tree based approach isn't really comparable.
> 
> 
> Me? Radix tree based approach? That approach is in the kernel. Do not 
> create a solution where there is no problem. If we do not want to 
> support large blocksizes then lets be honest and say so instead of 
> redefining what a block is. The current approach is fine if one is 
> satisfied with scatter gather and the VM overhead coming with handling 
> these pages. I fail to see what any of what you are proposing would add to 
> that.

I'm not just making this up. Fragmentation. OK?

-- 
SUSE Labs, Novell Inc.
