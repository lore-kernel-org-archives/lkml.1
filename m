Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbZLKBs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbZLKBs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbZLKBs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:48:56 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52204 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZLKBsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:48:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E7q9N6UdjNH7chRhzpDS/CmdXPrBKYAj7ZI0SbJWbuBrwlCfSso5922AClV4gdiIDL
         6I7pSSmW4WweLqMD6yC3q/8nmHWtLp6a0DDxomoBWmNKZFiwi5bmEuTlI8ZSmhPlC+UM
         xZfFpxVyOG32kfzk1xca+DNpditHr8cPCcsrI=
MIME-Version: 1.0
In-Reply-To: <20091210095422.3c5a75d1@jbarnes-piketon>
References: <4B1A6F78.8010408@myrealbox.com>
	 <50CA8D92EC%linux@youmustbejoking.demon.co.uk>
	 <20091206173222.4c2d5aaa@jbarnes-piketon>
	 <c1f41c620912061952k4945a7c8j4567ab17424e4d91@mail.gmail.com>
	 <c1f41c620912070538y4f865cechf21d2802ab237510@mail.gmail.com>
	 <c1f41c620912080520o7e0a69bdg7b885b4a17c6dbc@mail.gmail.com>
	 <20091210095422.3c5a75d1@jbarnes-piketon>
Date: Fri, 11 Dec 2009 08:49:01 +0700
Message-ID: <c1f41c620912101749x2e3c8e9fg2a40666d62bf38f5@mail.gmail.com>
Subject: Re: 2.6.31 -> 2.6.32 Sound and video regressions
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       luto@myrealbox.com, eric@anholt.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:54 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 8 Dec 2009 20:20:07 +0700
> Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
>> On Mon, Dec 7, 2009 at 8:38 PM, Emmanuel Benisty
>> <benisty.e@gmail.com> wrote:
>> >> It *seems* that we are facing two different issues here (I don't
>> >> even use S2R and the problem is there since the very first second
>> >> I start X). Anyway, I have bisected the problem on my box, it
>> >> turns out to be this one:
>> >>
>> >> drm/i915: Fix render reclock availability detection
>> >>
>> >> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=181a5336d6cc836f05507410d66988c483ad0154
>> >>
>> > So, I have reverted this commit and rebuilt 2.6.32. It completely
>> > solved the issue described in my first post.
>> >
>>
>> just FTR, it looks like I'm not alone:
>> http://forums.gentoo.org/viewtopic-p-6087556.html#6087556
>
> Great, thanks for narrowing it down.  I'll see if I can come up with a
> fix.

Thank you very much Jesse, I've opened a bug report here:
http://bugzilla.kernel.org/show_bug.cgi?id=14781
