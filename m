Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYCZOJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYCZOJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYCZOJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:09:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50958 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbYCZOJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:09:46 -0400
Message-ID: <47EA591F.9020507@mev.co.uk>
Date: Wed, 26 Mar 2008 14:09:35 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080317)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Corrections to Documentation/rbtree.txt
References: <47E282F5.6090703@mev.co.uk> <200803201339.18618.rob@landley.net> <47E8DBBE.4030607@mev.co.uk> <200803251324.08769.rob@landley.net>
In-Reply-To: <200803251324.08769.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 14:09:37.0878 (UTC) FILETIME=[06C25F60:01C88F4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/08 18:24, Rob Landley wrote:
> On Tuesday 25 March 2008 06:02:22 Ian Abbott wrote:
>> On 20/03/08 18:39, Rob Landley wrote:
>>> On Thursday 20 March 2008 10:29:57 Ian Abbott wrote:
>>>> From: Ian Abbott <abbotti@mev.co.uk>
>>>>
>>>> The description of the rb_entry() macro in Documentation/rbtree.txt
>>>> seems incorrect. This patch improves it (hopefully).  Also I changed the
>>>> example code to call the previous 'my_search()' example instead of an
>>>> undefined 'mysearch()'.
>>> I have no objection to the patch (and the my_search thing seems like an
>>> obvious typo), but is there a reason to prefer rb_entry() rather than
>>> container_of()?  If so, the rationale might be a good thing to add to the
>>> documentation...
>> I don't know the rationale, but all the code I can see uses rb_entry()
>> and not container_of().
> 
> Except container_of() works, which is a nice thing to know, and it already 
> mentions rb_entry() as another way to do it.  If someone could explain _why_ 
> to use one over the other, that would be a good thing to add.

Let's see if Andrea Arcangeli can still remember the rationale from 9 
years ago! :-)

container_of() works just as well, but _none_ of the existing code in 
the kernel uses it to access the container of the struct rb_node; they 
all use rb_entry(), including the example code in include/linux/rbtree.h.

> Again, I don't care much either way, I just want to know what the point is of 
> choosing one over the other that makes changing what's there worth bothering 
> with.  You're changing the documentation to hide the fact that rb_entry() is 
> basically another name for container_of(), and this is supposed to be an 
> improvement?

Personally I have no preference for rb_entry() over container_of(), but 
as all the code in the kernel uses rb_entry() it seems better if the 
examples in the documentation use it too.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
