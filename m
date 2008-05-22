Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbYEVAd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbYEVAd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762870AbYEVAcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:32:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:37612 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761347AbYEVAcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fg4uxdo70/lsnTizSaiOEH7Y5/aLD4IUJ9rXcWIE1GS3R+e/xPz52VdOmk4BtgPhHYAjb4zRy+n7Ey7Kw/UySIm5qDCZZuL2G9QAB1lSVAZWlIE7Bf2Iv2LCRlxk9EdvBpjse+s6J0PPvBghF21P1utV1R9B/Kg15TVx7gM+3DQ=
Message-ID: <9a8748490805211732l521f3d81xa34ea1ad6365bf2a@mail.gmail.com>
Date: Thu, 22 May 2008 02:32:25 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080522001233.GE16376@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	 <32279.1211401651@vena.lwn.net>
	 <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
	 <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
	 <20080522001233.GE16376@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Adrian Bunk <bunk@kernel.org>:
> On Thu, May 22, 2008 at 01:46:28AM +0200, Jesper Juhl wrote:
>>...
>> 2. How to find things to work on as a beginner
>>...
>> Finding bugs to fix is easy. Here are some ways to find useful work to
>> do:
>>...
>
> But fixing them is not so easy...
>
> Sorry for being destructive, but we do not have easy coding tasks
> for newbies.
>
A) You are not being destructive, you are doing exactely what I hoped
people would do, which is comment on my draft so I can make it better
:)

B) You are absolutely right in saying that fixing bugs is not (always)
easy. But it's a fact that many people ask questions along the lines
of "where do I start?", "where can I find something useful to work
on?", "I want to learn, is there some code that needs attention I can
start reading?" and similar. I'm simply trying to help the people who
ask that sort of questions by providing them with a source of stuff to
attack. Whether or not someone will be able to fix a bug is a
different issue to whether or not a person can find somewhere to start
getting into kernel development in a useful way.

> If it's easy it's already fixed,

True, and then again, not always.  Do 100 randconfig builds and I'm
willing to bet that at least a handful of the compiler errors or
warnings you encounter can be fixed by simply including a header,
moving an #ifdef, fixing a cast, fixing a printk format string or
similar.
There are many difficult to fix bugs in the kernel, but there's also
still some low-hanging fruit left (and I suspect there will always
be).

>and dozens of people following your
> advice to look at e.g. compile or sparse warnings will only generate
> much noise, but they'll have a hard time finding anything they are
> capable to fix.
>
You may be right, but personally I'm not so sure. The kernel is a
large project and we have many people who want to get involved but
give up when hitting the very first barrier to entry; finding
somewhere to start. Sure, there will be some noise, but I would hope
that there would also be many good (if somewhat trivial) patches - and
once people get one or two trivial patches accepted they may be
encouraged to delve in deeper and do more useful work.
Those that can't even fix a simple warning or missing include file
error will probably give up whether or not we provide this document or
not.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
