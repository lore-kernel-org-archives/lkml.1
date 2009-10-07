Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbZJGBXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbZJGBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZJGBXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:23:16 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:55647 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611AbZJGBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EX3+bEKRfdH2gzsoku/suLhPGU1/3Zlf3wRwjgdVKzxE/JTiLBuCjoIdLYRsm2z/Bs
         G075mTfPFYlC9UPlqPPpIBh4kwIp/xyLVJtk2VopD9qAAmOJkR7fCvQRTdpA90xDWCYk
         l18CJFJVd62TXLHbuj8JJOj8UnsyEuU1AAIkU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254864803.6035.25.camel@pasglop>
	 <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
Date: Wed, 7 Oct 2009 11:22:38 +1000
Message-ID: <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
Subject: Re: Linux 2.6.32-rc3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 8:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 7 Oct 2009, Benjamin Herrenschmidt wrote:
>>
>> Sure, when doing the stuff ourselves. Again, the problem is user
>> reports. Being able to distinguish between a 2.6.x "release" kernel and
>> anything else would be of value, at least to me.
>
> Why are you arguing? CONFIG_LOCALVERSION_AUTO gives exactly that?
>
> Also, why do you think that "release" is any special? All the same things
> are true about "is it -rc1 or is it -rc1-351-g58e57fb? When it comes to a
> bug-report, the difference between the two can be huge.
>
>> I disagree. I understand the linearity problem. My point isn't about
>> having the Makefile provide with any kind of precise "pointer" into that
>> tree for non-release, but really only to differenciate a release from
>> anything else.
>
> And your point is totally destroyed by any amount of thinking. Which you
> clearly didn't do.
>
> I repeat: there are tons of kernels that would not be based directly on
> that "-rc0" commit. You would confuse _those_ cases even more, because you
> would now think that they are somehow "release" kernels.
>
> And the fact is, NONE OF YOUR BLATHERING has in any way shown why people
> shouldn't just use CONFIG_LOCALVERSION_AUTO.
>
> I keep on returning to that, and harping on it, but the point is, WE
> ALREADY SOLVED THIS PROBLEM. Every single person who asks for a -rc0 tag
> is just being stupid. You already have a much superior solution.
>
> So don't ask me for something _stupid_, when you already have the smart
> thing!

Why don't you just have the kernel version Linux-commitid?

why keep up the pretense that the 2.6.xx bit means anything outside of release?

You could just have the tarball generation scripts make it into a 2.6.31 but
for everyone else we never see it.

Dave.
