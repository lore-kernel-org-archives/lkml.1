Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZD0I4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZD0I4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZD0I4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:56:30 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46175 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZD0I43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I51+T11NEHNsyAYnw9DLUB0y5DERb7jdSuZJRWU7rnjMYSdCfRqO2i/5otkPoov4sk
         sZ4NQ+57JRwn8f2/9sKq8RjB3WAVXUxh4r/lpn+Cs+6l3DXvQRuFhx167wFdtH0uz4dR
         zLxxrwlehwDjykFSo10SxZdmQxjUlSV9m/Y50=
MIME-Version: 1.0
In-Reply-To: <20090427083935.GA20941@elte.hu>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu>
Date: Mon, 27 Apr 2009 18:56:27 +1000
Message-ID: <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com>
Subject: Re: kms in defconfig
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 6:39 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Airlie <airlied@gmail.com> wrote:
>
>> Hi guys,
>>
>> I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
>>
>> This should never be the case, as anyone who built defconfig
>> kernels before, will now get KMS enabled when really they need to
>> have done userspace upgrades.
>
> I've yet to see such a bugreport.
>
> But i dont have particularly strong feelings about defconfigs: less
> than 1% of all kernel developers use them - which transforms into
> less than 0.01% of all Linux users.
>
> KMS is off by default in 'make oldconfig', right? That's all that
> matters really.

My main worry is distro configs going forward, where they pull something
from defconfig, granted I've no idea if that'll happen, maybe distro kernel
maintainers are smarter than I give them credit for :-)

> defconfigs _do_ change and there was never a compatibility rule for
> defconfigs. Arch defconfig is more of a signal towards what the
> architecture maintainers consider sane and supportable (or
> desirable) defaults - and it is also what developers working on
> arch/x86 should consider as the main thrust of features.
>
> That's an extremely long period of migration. I also think it's
> unreasonable: we dont want to draw out the migration from
> DRI1+user-space-mode-setting to DRI2+KMS that long. KMS should have
> been implemented and made the default 4-5 years _ago_ i think.
>
> KMS is the sane design for graphics and i'd go as far as to consider
> user-space mode setting an outright _bug_. It look a long time to
> fix but now lets look forward and fix all the bugs in KMS, ASAP ...

Its mainly for things like Andrews Vaio, people will not expect a new kernel
to take out any current userspace, its a pain, but we assume distros + people
who compile their own kernels will know what userspace exists on their
machines and other will get the least surprise.

Dave.

>
>        Ingo
>
