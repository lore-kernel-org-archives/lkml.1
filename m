Return-Path: <linux-kernel-owner+w=401wt.eu-S1161575AbXDLGjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161575AbXDLGjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 02:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161580AbXDLGjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 02:39:00 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:38625 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161577AbXDLGi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 02:38:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=A255yKQ87A3aS/PGD8tUJhxa/VyU5+Jl5El+OXcLlijJ6pg45H3xItq8m4XgfKDkZlzyIKsWKS8YcE4dk9YT9WxpWUgKuubnGZOUbYtbebOxF5vrjmi4Q25AfytN5MiAAq4OJft50Fc3XNJQApuXvRY187tAkcJI41wlc2aO5XM=  ;
X-YMail-OSG: gT3wB98VM1lSLkhBGPcEKVSYb5DjqorQkXxBz2AdjQcXVLNsEldo_Cm9pKAJxciFlLOlZ1HksQ--
Message-ID: <461DD3FD.3070803@yahoo.com.au>
Date: Thu, 12 Apr 2007 16:38:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
References: <7.469046093@selenic.com> <461C81C0.9040003@yahoo.com.au> <20070411144009.GD11115@waste.org>
In-Reply-To: <20070411144009.GD11115@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Wed, Apr 11, 2007 at 04:35:44PM +1000, Nick Piggin wrote:
> 
>>Matt Mackall wrote:
>>
>>>Move the page walker code to lib/
>>>
>>>This lets it get shared outside of proc/ and linked in only when
>>>needed.
>>
>>Still should go into mm/
>>
>>If it had, you might have also noticed your pagetable walking code
>>is completely different from how everyone else does it, and fixed
>>that too.
> 
> 
> I actually did notice that, when I compared it to jsgf's page walking
> code for Xen.

Can you fix it then, since you are doing the big reorganisation?

>  
> 
>>BTW. Is it the case that unused and unexported symbols don't get
>>pruned by the linker except inside lib/?
> 
> 
> Yes, that's been my point all along. It also currently only happens at
> the granularity of an object file, not a symbol, FYI.

You have the config symbols, don't you? Please use them in the
makefile to prevent compiling and linking.

My point all along is that it belongs in mm/. If you don't want to
do it then I can't make you, but I'll submit a patch to use the
correct page table walking conventions and move it to mm/.

-- 
SUSE Labs, Novell Inc.
