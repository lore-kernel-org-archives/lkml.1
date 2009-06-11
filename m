Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbZFKLMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbZFKLMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbZFKLMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:12:41 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17363 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZFKLMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:12:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DTf8LePVxpc0vWnm1uoQC0h8a6PalDM2aZ1jPR2JYtKQqKbbB2puCb+Kgish4Yc4Y
	EwGwkS9+LhRvv/KfBFQEg==
MIME-Version: 1.0
In-Reply-To: <20090611103457.GG795@n2100.arm.linux.org.uk>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <20090611.000219.206893038.davem@davemloft.net>
	 <20090611073740.GB8592@elf.ucw.cz>
	 <20090611103457.GG795@n2100.arm.linux.org.uk>
Date: Thu, 11 Jun 2009 04:12:39 -0700
Message-ID: <a55d774e0906110412w7121d6d3t526ebd9c04d2d205@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 3:34 AM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
>
> However, as a result of the complete lack of effort to update patches
> as a result of feedback coupled with my lack of bandwidth to review
> complex code implementing things like cross-bridge APIs (eg, ARM <->
> DSP communications channels), Brian basically gave up trying to get
> stuff into mainline.

Well, "gave up" feels a little final to me.  We still would like to
get stuff upstream.  I will admit to finding the process discouraging
at times, but a larger part of it is just finding the time to sit
down, tidy up the current state of our world against the tip-of-tree
on mainline, and push out another round of patches.  I'm hoping to
find some larger windows of time to devote to this later this year.

Since we also have to maintain a stable, shippable tree for products
going out the door and to provide baseline support for the platform,
we end up having to maintain multiple trees -- it's obviously not
realistic to expect that we're going to get 30000-50000 lines of new
code reviewed quickly, but we do need all the functionality there to
actually support shipping devices.  When time gets tight (more often
than I like), the towards-mainline stuff gets backburnered.
Obviously, we suffer for this in that we end up having more to rebase
every time we move forward, so it would be to our benefit to get
better at pushing this stuff upstream and reduce the delta between
mainline and our tree.

> Now, ask yourself this question: why should I have to be the one to
> review things like ARM <-> DSP communication channel code?  Hint: I
> don't want to because I know nothing about the subject.  Where should
> I send these people to get such code reviewed?  No idea, there seems
> to be no one _anywhere_ who would seem to be interested in it.

The drivers/staging system looks like it has some potential to help
here.  Greg has been scooping our generic code into there recently,
and I know Arve's seen patches for binder issues go by, etc.  It feels
(if I'm understanding the intent) a bit more like the model I'm more
used to (get a relatively clean piece of code that is functional
checked in, and then refine it).

> Andrew tried to resolve this review problem by getting some co-operation
> between various members of the ARM community - so that two or three
> people with large code bases would do mutual reviews and gain from
> each others efforts.  The result of that was... precisely nothing.  No
> interest in lifting a finger to help someone else.

I think Andrew's idea is a good one, but we just haven't had the time
to try to sort this out.  I'll have to see what we can do here.
Recently, we've been involved in omap3 work as well and have been
interacting more with folks in the omap kernel community as a result.

Brian
