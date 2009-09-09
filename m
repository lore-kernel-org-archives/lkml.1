Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZIIVxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZIIVxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZIIVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:53:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZIIVxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:53:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=D0zbhINAm8pwpv+WagJzEnTH86t77uGtmMrn6nujEErygJIL4IUJgpKqjlfUpJ1zN
	xfyThaR0QIAS/Fo/9eo4g==
MIME-Version: 1.0
In-Reply-To: <1252505941.14793.97.camel@desktop>
References: <20090903041429.GA29875@kroah.com> <20090906052819.GE1324@ucw.cz>
	 <1252338939.2139.21.camel@desktop> <20090909095702.GB28615@elf.ucw.cz>
	 <1252505941.14793.97.camel@desktop>
Date: Wed, 9 Sep 2009 14:53:45 -0700
Message-ID: <a55d774e0909091453l5f658212wa3fe3df685a353c@mail.gmail.com>
Subject: Re: Staging tree status for the .32 kernel merge
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       "Huntsman, Bryan" <bryanh@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 7:19 AM, Daniel Walker<dwalker@fifo99.com> wrote:
> On Wed, 2009-09-09 at 11:57 +0200, Pavel Machek wrote:
>> Hi!
>> > > >           Note, Pavel has been adding some of the Dream hardware
>> > > >           drivers, which are separate from the core Android drivers.  I
>> > > >           have no objection to those, but they should work to get merged
>> > > >           to their "correct" places in the tree in another release or
>> > > >           so.
>> > >
>> > > Well, some of those drivers should be moderately easy (touchscreen),
>> > > but some (camera) will take longer than that. For example camera --
>> > > contains _lots_ of code, and uses obsolete v4l api.
>> > >
>> > > Plus, I really need to get recent kernel to boot and then get arch/arm
>> > > pieces merged....
>> >
>> > I've got a tree with a lot of the arch/arm/msm pieces isolated, doesn't
>> > boot yet .. I had to drop certain parts like the key pad support since
>> > it had a big generic change attached to it .. It's all part of a git
>> > tree which I can expose if you want to look at it.
>>
>> Yes, minimal, but booting version would be very welcome. I tried to
>> produce exactly that few times, but did not succeed (yet).
>
> Last night I discovered maybe a better tree to use ..
>
> https://www.codeaurora.org/gitweb/quic/kernel/?p=bryanh/linux-2.6.git;a=summary
>
> It's based off a newer kernel 2.6.31-rc6 . I have a feeling it's minus a
> lot of the google stuff.

That would be somewhat surprising, since the qct/quicinc folks support
the full android stack on top of their kernels (though we're not
entirely converged at this point).

Not sure if their tree has full support for devices like
dream/sapphire/etc -- I believe they primarily verify on their SURF
platform.  Added Bryan to the CC so he can comment.

Brian
