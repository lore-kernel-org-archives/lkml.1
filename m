Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYKUOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYKUOUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYKUOUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:20:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:7629 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYKUOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZZsUonOPa08MpcYCO1464LdX5Xgr5NmdPVSF42iA/C+eV7a6m59tHkAho91PjETjGn
         v7pLE3BZkan/XBLPYtj8v4j6xbUsvAiFNoQVyoFsfGevZfudN3wHtiKpEtCjmk9EKQI4
         bs9KBlLQ+j+3nIDlNSz+rAh1xKaxYF4Kr801M=
Message-ID: <517f3f820811210620o34307610hf926bbe3b3828e8c@mail.gmail.com>
Date: Fri, 21 Nov 2008 09:20:39 -0500
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Pavel Machek" <pavel@suse.cz>, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@lst.de>,
       "John McCutchan" <john@johnmccutchan.com>
In-Reply-To: <20081121140325.GA12384@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
	 <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
	 <20081117171508.GA564@ioremap.net>
	 <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com>
	 <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz>
	 <20081121140325.GA12384@ioremap.net>
X-Google-Sender-Auth: f06687f32dc706c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > And I actually answered, that this may be a good idea for the new
>> > project. Although if things work right now no one will ever try to
>> > change it. It does not work in my case, so I need to invent as simple
>> > as possible way to fix it.
>>
>> 'as simple diff as possible' is pretty bad criterium for kernel
>> merges.
>
> Critics without suggestions is useless. What did you try to say here?
> You you believe it should be done in a different way, please tell us how
> you see this should be implemented.

Hi Evgeniy,

I think the point is this.  You want to introduce a change that
address the needs of a single application.  Many others see the
change, which though it may be simple and quick to implement, as "an
ugly hack" -- it messes up an otherwise rather well designed API.
Should we make such a change?  I think not -- and others are echoing
that sentiment.  Your argument that "we should do this because no-one
else has proposed a better way" is not sufficient rationale for
uglifying this API to serve the needs of a single app -- the argument
will not fly, no matter how many times you repeat it.  (Your statement
"Critics without suggestions is useless" does not hold: one very
useful purpose of critics is to maintain the status quo of "good
taste" in API design.)

At this stage, I see three possibilities -- you maintain an
out-of-mainline patch for the kernel, and distribute that with your
app; you work out some other *userspace* solution to your problem; or
someone comes up with inotify-ng, designed to address your needs and
those of others (okay, we may not know what those other needs are yet,
but the question is if we could come up with an inotify-ng design that
can extensible in a sane way).  I know that none of these options will
be what you are happy with, but all of them have more life than your
proposal, IMO.

Cheers,

Michael
