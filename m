Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZC0XWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZC0XWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZC0XW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:22:27 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:39915 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922AbZC0XW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:22:26 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net 692432C2CB2
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux 2.6.29
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 28 Mar 2009 00:22:22 +0100
References: <cj1Ut-1i2-7@gated-at.bofh.it> <cj8ji-35a-5@gated-at.bofh.it> <cj8CC-3uO-5@gated-at.bofh.it> <cj9oW-4PO-1@gated-at.bofh.it> <cjkaL-5xg-15@gated-at.bofh.it> <cjGbn-6Xx-35@gated-at.bofh.it> <cjGl4-7ak-61@gated-at.bofh.it> <cjJsv-3Uu-5@gated-at.bofh.it> <cjKHX-5MF-19@gated-at.bofh.it> <ck7XP-JA-13@gated-at.bofh.it> <ck8h7-18H-1@gated-at.bofh.it> <ck8AA-1y0-7@gated-at.bofh.it> <ck8Kd-20o-7@gated-at.bofh.it> <ck93x-2oJ-3@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnLNW-00027R-FP@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 26 Mar 2009 18:03:15 -0700 (PDT) Linus Torvalds
>> On Thu, 26 Mar 2009, Andrew Morton wrote:

>> > userspace can get closer than the kernel can.
>> 
>> Andrew, that's SIMPLY NOT TRUE.
>> 
>> You state that without any amount of data to back it up, as if it was some
>> kind of truism. It's not.
> 
> I've seen you repeatedly fiddle the in-kernel defaults based on
> in-field experience.  That could just as easily have been done in
> initscripts by distros, and much more effectively because it doesn't
> need a new kernel.  That's data.
> 
> The fact that this hasn't even been _attempted_ (afaik) is deplorable.
> 
> Why does everyone just sit around waiting for the kernel to put a new
> value into two magic numbers which userspace scripts could have set?

Because the user controlling userspace does not understand your knobs.
I want to say "file cache minimum 128 MB (otherwise my system crawls),
max 1,5 GB (or the same happens due to swapping)". Maybe I'll want to say
"start writing if you have data for one second of max. transfer rate"
(obviously a per-device setting).

> My /etc/rc.local has been tweaking dirty_ratio, dirty_background_ratio
> and swappiness for many years.  I guess I'm just incredibly advanced.

These settings are good, but they can't prevent the filecache from
growing until the mouse driver gets swapped out.

You happened to find good settings for your setup. Maybe I did once, too,
but it stopped working for the pathological cases in which I'd need
tweaking (which includes normal operation on my laptop), and having a
numeric swappiness without units or a guide did not help. And instead of
dedicating a week to loading NASA images in GIMP (which was a pathological
case on my old desktop) in order to find acceptable settings, I just didn't
do that then.


