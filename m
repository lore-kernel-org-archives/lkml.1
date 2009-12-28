Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZL1VIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZL1VIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZL1VIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:08:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZL1VIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:08:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nms8frzvBNLFgbHYknbB1I2YuZuEIj/Pzl5/MF/TQthGP8oPNpE72fF0xkpgRZI12
	MAcWEJtOmwGjD40GfYgww==
MIME-Version: 1.0
In-Reply-To: <20091228204848.GB1637@ucw.cz>
References: <20091213212504.GD5114@elf.ucw.cz>
	 <20091227093537.GD11737@elf.ucw.cz>
	 <20091227201514.GA29174@elf.ucw.cz>
	 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
	 <20091227203704.GK11737@elf.ucw.cz>
	 <20091227211322.GB29174@elf.ucw.cz>
	 <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
	 <20091227101824.GB1478@ucw.cz>
	 <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com>
	 <20091228204848.GB1637@ucw.cz>
Date: Mon, 28 Dec 2009 13:08:27 -0800
Message-ID: <a55d774e0912281308u1c20c84cl4f264aa366445131@mail.gmail.com>
Subject: Re: tree with htc dream support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 12:48 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > In the short run... the code is staging quality, so it should be in
>> > staging... and you'll not have to mainain so huge diff. (-20 kLoc).
>>
>> The core smd stuff is really not that large.  The central smd.[ch] are
>> about 1300 lines, and proc_comm.[ch] are about 400 lines.  Is it
>> possible to get some review/feedback as to what's "staging quality"
>> about this code so we can clean it up?  I'd rather just fix the
>> issues
>
> Just submit it to Daniel W., ccing rmk and l-a-k, and I'm sure you'll
> get feedback.
>
> For a start, checkpatch has some mild complains.
>
>> and get the core stuff in there so clock, power, etc support is there
>> for the platform rather than have it live in staging purgatory.
>>
>> Since this stuff is integral to mach-msm, required for essential
>> operation of the platform, and makes sense to be part of the mach-msm
>> codebase, why not just fix it there rather than move it out into
>> staging and then back?  I'm not sure what that gains us.
>
> Well, it is in staging now. I just want you to use the existing
> version, instead of adding another one.

I'm trying to understand where the version in staging came from, how
it's been changed, etc, so I can resolve that against what we have
that's known good and shipping today and make sure we're not losing
bugfixes and such along the way.

Do you remember where the smd code that you put into staging came
from, exactly?  Unfortunately since things have been moved, modified,
renamed, etc, getting clean diffs is a bit of an adventure right now.

When I'm back in the office (on vacation at the moment, trying to stay
caught up on email though) I'll have to start figuring out what went
where and how different it is from what we have today, say in Arve's
.33 based tree.

Brian
