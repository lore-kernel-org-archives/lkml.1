Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZCCJd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZCCJd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZCCJdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:33:19 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59437 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbZCCJdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:33:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NH6C2v9xK0FYThUVtrwUrGLHXfEwy1VKx9A8LeCfxpIwgYVgzhqxsOrgKZoF4rU+ci
         lTTtC8XlX1Wjrpg3FEHeiKutLc/hXgQgaEftgvTtN801BquH3LNtdQROc6PTsS94WPpJ
         sHBflVz18Tnjbb5XmIxExgL0wMdhvN5YjSLIQ=
MIME-Version: 1.0
In-Reply-To: <82ecf08e0903020942i55e1a31bn983c2ce243e342e9@mail.gmail.com>
References: <1236007103.18284.83.camel@penberg-laptop>
	 <82ecf08e0903020750q3670de6u4162e4f01c847003@mail.gmail.com>
	 <1236014911.18284.89.camel@penberg-laptop>
	 <82ecf08e0903020942i55e1a31bn983c2ce243e342e9@mail.gmail.com>
Date: Tue, 3 Mar 2009 09:33:15 +0000
Message-ID: <87a5b0800903030133y7bd22204y4995657cfd75950f@mail.gmail.com>
Subject: Re: [PATCH] crc32: remove useless __pure modifier from functions
From: Will Newton <will.newton@gmail.com>
To: Thiago Galesi <thiagogalesi@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 5:42 PM, Thiago Galesi <thiagogalesi@gmail.com> wrote:
>>
>> Hmm. They're not marked as pure in the header files. Does GCC look it up
>> from the object file or something for this...?
>
> I just tested this, the answer is No :(
>
> It only works if it's marked in the header. But when it's marked, it
> works, and redundant calls are optimized.

Did you see any change in size of your kernel with this annotation? It
didn't seem to have any effect as far as I could tell.

There are a number of functions in lib/ code that could be marked
__pure or __attribute_const__ but I'm not sure if it's worth the
effort, for my compiler (gcc 4.2) at least.
