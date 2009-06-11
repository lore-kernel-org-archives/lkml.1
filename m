Return-Path: <linux-kernel-owner+w=401wt.eu-S1761175AbZFKI2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175AbZFKI2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbZFKI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:27:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZFKI1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:27:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=G1E6ueT3gBvhMlEk/tWJBpwt/tjpnOTjsq6ncrvw8RGY6IbJ6/GOTtrP+oOicEJ9D
	ZDyj8gShrrNKoAdNNwvgA==
MIME-Version: 1.0
In-Reply-To: <20090611081012.GD8592@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com>
	 <20090611081012.GD8592@elf.ucw.cz>
Date: Thu, 11 Jun 2009 01:27:43 -0700
Message-ID: <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 1:10 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Wed 2009-06-10 10:43:53, Brian Swetland wrote:
>>
>> Our current working tree (for the donut branch) is against 2.6.29:
>> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
>
> Strange, I attempted downloading this overnight (285MB!)

Hm.  I think if you add this as a remote to an existing repository
containing the kernel (these trees are based on v2.6.27 and v2.6.29
respectively) it should only pull the deltas (which aren't that
enormous).

>> The cupcake/1.5 system update (latest production kernel) was against 2.6.27:
>> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.27
>>
>> > Is all of it neccessary for dream or are parts such as board-halibut
>> > parts of some other support? Do I have wrong tree entirely?
>>
>> Most of it is necessary.  board-halibut is a qualcomm reference
>> design.  board-sapphire is HTC Magic.  board-trout is G1/ADP1.
>> arch/arm/config/msm_defconfig is how we configure the kernel we ship
>> which supports all three.
>
> Ok, could we get the boards renamed? g1 is known as dream, having
> trout+dream+g1+adp1 names for same piece of hardware is unnice.

It's hard to have a single name since carriers tend to use different
names in different markets.  We often start work on kernel support
long before a product is announced, so we've been using the fish names
to allow us to register board names with the ARM machine registry
early on and not use bogus internal-only machine IDs.

> Hmm, perhaps this would be useful to apply?

I didn't realize we had an android.txt already under Documentation.
Expanding it with more details sounds good to me.

halibut - Qualcomm SURF 7201A
trout - HTC Dream, Android ADP1, T-Mobile G1
sapphire - HTC Sapphire, HTC Magic

There may be some other names used by other carriers or in other regions.

Brian
