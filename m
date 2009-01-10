Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZAJB3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZAJB3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZAJB27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:28:59 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42496 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbZAJB26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lV7OkwioYCSKSsFpuFeBzWVDL9Ojdd4sIDdjNLtaUvtpLItY99OQRU3JgKjJu5hID+
         nDrdriLvR5VQ0aBnb4bolSz7iyj0m44CBXjD7yA9j5bayFfu6jCH2we55ZogH8svYskz
         p/t/thLNgjBVQVMWeZgG/WJvDgMseplBHuLQ0=
Message-ID: <f19298770901091728ve5011c3m58e68d71b8550a67@mail.gmail.com>
Date: Sat, 10 Jan 2009 04:28:56 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [PATCH 0/5] [trivial] Fix dubious bitwise and/or usage.
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Trivial Kernel Patches" <trivial@kernel.org>
In-Reply-To: <alpine.LNX.1.10.0901100059010.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090109234113.11800.55672.stgit@zaytsev.su>
	 <alpine.LNX.1.10.0901100059010.5377@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 03:00, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 10 Jan 2009, Alexey Zaytsev wrote:
>
>> Sorry to bother the lkml with such trivial stuff, but I could not get
>> any response from either Jiri Kosina ot trivial@ when I sent the patches
>> directly to them. Maybe a linux-trivial@ mailing list would be a good
>> idea..
>
> Sorry, I have just been busy with too many other things during the merge
> window.
Sorry for the disturbance then. I was not sure if you received the patches.

>
>> ---
>>
>> Alexey Zaytsev (5):
>>       Fix dubious bitwise 'and' usage spotted by sparse.
>>       Fix dubious bitwise 'and' usage spotted by sparse.
>>       Fix dubious bitwise 'and' usage spotted by sparse.
>>       Fix dubious bitwise 'or' usage spotted by sparse.
>>       Fix dubious bitwise 'or' usage spotted by sparse.
>
> I have applied all the patches with exception for the one patching
> drivers/media/video/gspca/m5602/m5602_s5k4aa.c, as it doesn't apply any
> more.

Thank you. The bugs seem to be leaving by themselves. ;)
