Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbZD1Byx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbZD1Byx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZD1Byn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:54:43 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:32268 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZD1Bym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J+wwZmWWCHPCRNULQW6GqWFwIj0wlav5QNAUJ6XobvDoZru8TQ85lhXM9eeVUDAo9t
         GcCbShhGCQCsrpDcpZyrZUDDBQoX4huqB3BzWkfOepAIOMv0sBG5/vWJbwR0Z8g0XKLC
         l5/kRuqoo78Y9z4aC0ad5Zpzk5gfvZBeba0UQ=
MIME-Version: 1.0
In-Reply-To: <1240846843.7620.32.camel@twins>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu> <1240846843.7620.32.camel@twins>
Date: Tue, 28 Apr 2009 11:54:41 +1000
Message-ID: <21d7e9970904271854q68242f08pb3f8e12f0ddb6506@mail.gmail.com>
Subject: Re: kms in defconfig
From: Dave Airlie <airlied@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 1:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-04-27 at 10:39 +0200, Ingo Molnar wrote:
>> * Dave Airlie <airlied@gmail.com> wrote:
>>
>> > Hi guys,
>> >
>> > I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
>> >
>> > This should never be the case, as anyone who built defconfig
>> > kernels before, will now get KMS enabled when really they need to
>> > have done userspace upgrades.
>>
>> I've yet to see such a bugreport.
>
> Whenever I accidentally enable KMS I get a dead X (happens way more
> often that I'd like to), I blame this on the ubuntu Xorg packages, but
> can't be arsed to fix it myself -- hopefully the kinky koala will fix
> stuff, but who knows.

Well you can't really blame anyone else for it, since you have to put
the code upstream
in the kernel before you can release drivers that use it for distros to package.

So it would be impossible for any distro to have shipped kms drivers in a useful
fashion before KMS is actually in the kernel.

Dave.
