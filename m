Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZACEWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZACEWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbZACEWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:22:13 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:43161 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZACEWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZOrTY7yuWwNcT8poJavSkPvJfWKkyv3oPTfvkmwH4uQISUgof0xbyg+3yZtCqsJS6D
         wGd2et0Nl872KWCeDy6ggmliOvC/gOr49QhZJKleAUxHfkjyopw/50UB3XgltU+1QzJr
         AAOHHKWeS/qqjR/86sTPkw5FCUOwrDy792R20=
Message-ID: <73c1f2160901022022r21586980t67e8baf485183ac7@mail.gmail.com>
Date: Fri, 2 Jan 2009 23:22:09 -0500
From: "Brian Gerst" <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: PDA changes (take 3)
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "the arch/x86 maintainers" <x86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 3:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Brian Gerst wrote:
>> Here are the PDA patches again.  I changed the first patch so that the PDA is cacheline
>> aligned.  I dropped the cpunumber patch for now, and added conversions of the TLB state
>> and IRQ stats to match the 32-bit code.  Stats for defconfig:
>>
>>   text    data     bss     dec     hex filename
>> 7033649 1754476  758508 9546633  91ab89 vmlinux.before
>> 7029643 1754716  758508 9542867  919cd3 vmlinux.after
>>
>> Patches are against 2.6.28.
>
> Hi there,
>
> I just tried to apply your patchset, but it fails rather dramatically on
> patch 3.  Could you refresh it against tip:master or current Linus git?

It was a conflict with commit 915b0d0104b72fd36af088ba4b11b5690bc96a6c
(x86: hardirq: introduce inc_irq_stat()).  Resending the series
rebased against current Linus git.

--
Brian Gerst
