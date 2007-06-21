Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbXFVN5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbXFVN5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXFVN4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:56:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:35704 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXFVN4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:56:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=M+kKv8f8DAB19FBSbVD2LhrWHmp8xNd4mBr1nhPYfvUR7Qalm6ZvvVZ5fTdEl7AilKtCvh71uHP7m4xkqbmwOGh1oltW1w0bV4Yr4hAsYrQ1Q+ooaVu9Lv2M3qlv7C+9hZxFVEYOQZho4F0jrGh0LVO6uMJyeBUMhTlVljTVP6Q=
Date: Thu, 21 Jun 2007 23:11:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bracing the loop in kernel/softirq.c
Message-ID: <20070621191109.GA13853@cvg>
References: <20070620175737.GA6523@cvg> <9a8748490706201401m36b1e917g5a600951d48e4cf8@mail.gmail.com> <467AC8E9.1000605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467AC8E9.1000605@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeremy Fitzhardinge - Thu, Jun 21, 2007 at 11:52:25AM -0700]
> Jesper Juhl wrote:
>> On 20/06/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> This trivial patch adds braces over a one-line
>>> loop. That makes code...well... little bit
>>> convenient for (possible) further modifications.
>>>
>> That's generally not done.
>>
>> It's even in Documentation/CodingStyle :
>>
>> "
>> Do not unnecessarily use braces where a single statement will do.
>>
>> if (condition)
>>        action();
>> "
>
> I tend to see "do {} while()" as an exception to this.  I find the 
> construct is sufficiently rare that it helps to emphasize it a bit.  For 
> example if I'm scanning code and I see:
>
> 	while (foo != NULL);
>
> in the corner of my eye, I'm going to think "huh?".  But:
>
> 	} while (foo != NULL);
>
> visually "parses" properly, regardless of how near or far the corresponding 
> "do  {" is.
>
> (And of course, its consistent with the super extra special while-while 
> loop:
>
> 	while (foo != NULL) {
> 		foo = bar();
> 		piffle();
> 	} while (foo != NULL);	// make sure we loop properly
>
> ;)
>
>    J
>

Indeed, 'do-while' is a special case.
Btw, Jeremy, I'm always getting into rapture on 'while-while' loop ;)

		Cyrill

