Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbXKDVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbXKDVv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 16:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXKDVvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 16:51:48 -0500
Received: from lucidpixels.com ([75.144.35.66]:38378 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbXKDVvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 16:51:47 -0500
Date: Sun, 4 Nov 2007 16:51:46 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Neil Brown <neilb@suse.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
In-Reply-To: <18222.16003.92062.970530@notabene.brown>
Message-ID: <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, Neil Brown wrote:

> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
>>
>> After several days/weeks, this is the second time this has happened, while
>> doing regular file I/O (decompressing a file), everything on the device
>> went into D-state.
>
> At a guess (I haven't looked closely) I'd say it is the bug that was
> meant to be fixed by
>
> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>
> except that patch applied badly and needed to be fixed with
> the following patch (not in git yet).
> These have been sent to stable@ and should be in the queue for 2.6.23.2
>

Ah, thanks Neil, will be updating as soon as it is released, thanks.

Justin.

