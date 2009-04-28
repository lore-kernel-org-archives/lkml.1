Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZD1XmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZD1XmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZD1XmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:42:08 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:56681 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZD1XmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AxD25NOycNu7FQC86NDIIXox0vu9bjkEqdZ2/dTfessSaKEQb5pgLKkPGUWKSqI9dF
         MO0Qg0aIET5NiTeqnf96aNfSHnDp8wgqk2uZaVpSklqqfWlHdQCz6CFd/R5v+7gyeHEf
         E9fv38J2mXidQ9nEKa9x2pnSVcILJiUpBgQO0=
MIME-Version: 1.0
In-Reply-To: <1240903942.7620.68.camel@twins>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>
	 <20090427083935.GA20941@elte.hu> <1240846843.7620.32.camel@twins>
	 <21d7e9970904271854q68242f08pb3f8e12f0ddb6506@mail.gmail.com>
	 <1240903942.7620.68.camel@twins>
Date: Wed, 29 Apr 2009 09:42:05 +1000
Message-ID: <21d7e9970904281642x348d9d26s153bc6f75159c262@mail.gmail.com>
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

On Tue, Apr 28, 2009 at 5:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-04-28 at 11:54 +1000, Dave Airlie wrote:
>> On Tue, Apr 28, 2009 at 1:40 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2009-04-27 at 10:39 +0200, Ingo Molnar wrote:
>> >> * Dave Airlie <airlied@gmail.com> wrote:
>> >>
>> >> > Hi guys,
>> >> >
>> >> > I just noticed CONFIG_DRM_I915_KMS is enabled for x86-64.
>> >> >
>> >> > This should never be the case, as anyone who built defconfig
>> >> > kernels before, will now get KMS enabled when really they need to
>> >> > have done userspace upgrades.
>> >>
>> >> I've yet to see such a bugreport.
>> >
>> > Whenever I accidentally enable KMS I get a dead X (happens way more
>> > often that I'd like to), I blame this on the ubuntu Xorg packages, but
>> > can't be arsed to fix it myself -- hopefully the kinky koala will fix
>> > stuff, but who knows.
>>
>> Well you can't really blame anyone else for it, since you have to put
>> the code upstream
>> in the kernel before you can release drivers that use it for distros to package.
>>
>> So it would be impossible for any distro to have shipped kms drivers in a useful
>> fashion before KMS is actually in the kernel.
>
> Can't the driver detect KMS and use it when present? In that case they
> could just ship a KMS capable driver that works either way.
>

Again it can't tell the future. The kernel can't know what userspace
driver is installed
or what driver the X server is going to run on it. So new drivers can
of course deal with both cases
as the userspace driver is kms aware, but a non-kms aware userspace cannot know
about KMS without time travel.

Once distros ship the kms aware userspaces then it should all work fine.

Dave.
