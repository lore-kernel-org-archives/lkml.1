Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbZDBAEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbZDBAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 20:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZDBAD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 20:03:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:21133 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZDBADz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 20:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FasOfDdS0XtkNGknS3kqEmVfpl30yEHlSeeMXpD2h3qj9N7mCZ7Wh6ZGppv0X0bQHT
         IjMfg+EeNFOHQDv9h5QhNjy48vpnQPfAYnJppGDz2S2WM/6hVW6gW48oyxknR0Jju6b3
         Sv2dCaOyynVCRDas3Lo16joA0u8QKDF5Ty5qg=
Message-ID: <49D400A5.20901@vflare.org>
Date: Thu, 02 Apr 2009 05:32:45 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: penberg@cs.helsinki.fi, cl@linux-foundation.org, edt@aei.ca,
       linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] compressed in-memory swapping take5
References: <49D0DBA2.20101@vflare.org> <20090401155743.685e2c1e.akpm@linux-foundation.org>
In-Reply-To: <20090401155743.685e2c1e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thanks for your reply. My comments inline.

Andrew Morton wrote:

>>   - Links to more performance numbers, use cases can be found at:
>> http://lkml.org/lkml/2009/3/17/116
> 
> The sole, whole, entire point of this patchset is performance.  Yet
> after chasing a few scruffy links, the only data we have to justify
> merging _any_ of this stuff is, and I quote,
> 
>  - The time of paging down one pdf page was reduced to 1/4~1/100
>  - The time of switching from one firefox tab to another was reduced to 1/6
>  - The capacity of kpdf was be increased from 2 pdf files to 11 pdf files.
>  - The capacity of firefox was increased from 6 web pages to 15 web pages.
> 
> that isn't very compelling!
> 
> So would it be possible for you to come up with some more concrete
> testing results to help convince us that we should make this change to
> Linux?  And include them front-and-centre in the changelog, and
> maintain it?
>

Fair enough. I will get these numbers and include them in changelog itself.
Probably by next kernel release.

> We would also be interested in seeing the performance _loss_ from these
> patches.  There must be some cost somewhere.  Find a worstish-case test
> case and run it and include its results in the changelog too, so we
> better understand the tradeoffs involved here.
> 

Sure. I will get these too.

> 
> I'm really reluctant to go and merge a complete new memory allocator
> just on behalf of an obscure driver.  Oh well, perhaps hiding it down
> in drivers/block was the right thing to do.


Justification for this custom allocator is present in xvmalloc changelog
itself. It gives reason for not using SLUB and SLOB. During review
cycle, I never got any arguments against that justification.

For possible inclusion in Linux, I will hide it in drivers/block/ramzswap
and rename interfaces to make sure that no-one else can use it.

> 
> As the patchset adds five tightly-related files, perhaps it should all
> live in drivers/block/rmazswap/?
> 
> 

Ok, no problem.


Thanks for reply.
Nitin

