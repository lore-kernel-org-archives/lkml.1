Return-Path: <linux-kernel-owner+w=401wt.eu-S1750949AbYAUMjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750949AbYAUMjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 07:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYAUMiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 07:38:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:54804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYAUMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lm6mFidTC3OKACavSVJEh6v33t1BUznfmm8DePysf5hrqMDLQjBMQjF+2wXMTcCfH6g/BvFghW6JJLlVF02TnX7La09IXhz1eNVbx2n6sb2iSRw8t1nRJ2viKsuT9QZq0yuH5dSCO6blq7DSBMin84XxupaiVi9thwayh4XLKvA=
Message-ID: <47949257.1000102@gmail.com>
Date: Mon, 21 Jan 2008 21:38:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
References: <200801202046.14746.rusty@rustcorp.com.au> <47934604.6080505@gmail.com> <200801210917.30977.rusty@rustcorp.com.au> <200801212233.04989.rusty@rustcorp.com.au>
In-Reply-To: <200801212233.04989.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Monday 21 January 2008 09:17:30 Rusty Russell wrote:
>> On Monday 21 January 2008 00:00:52 Tejun Heo wrote:
>>> What should be do are
>>>
>>> * Check that the threadfn's argument fits into void *.
>> For everything but timer, you'll get a warning if the data isn't assignable
>> to a void *, so you get a warning if you use a non-pointer already.
>>
>> But it would be cool to allow functions which take an unsigned long.
> ...
>> I'll test this out and see what I can make...
> 
> I think this comes under "too ugly", but here's an attempt.

Maybe we should be content with pointer type checking.  It seems like
it's going too far and after all the clutter it's not possible to use
int as argument.  :-(

Thanks.

-- 
tejun
