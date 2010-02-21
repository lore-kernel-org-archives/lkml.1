Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0BUCPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 21:15:05 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:63965 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab0BUCPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 21:15:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ohJvN+5hVMrnOhQGrVhk5mMdy49aRe8lMK4hufOyLULs99AFfZW6q7tcGZbUXTrxIs
         +lp1jw27q8wPNZnPbpBURUcJf5ejG7yhE68NIPDbgZgFEMCMy2iMKdFVc/SAiOgWgd94
         h5RGWvy9U9bu2Vx1Dae5qkEhW0HO8cKxi4oEo=
MIME-Version: 1.0
In-Reply-To: <4B80963D.4030707@shikadi.net>
References: <4B78EF9C.6040801@shikadi.net>
	 <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net>
	 <20100215122732.GM12076@hack.private> <4B79BC66.9090408@shikadi.net>
	 <20100220144529.GE3000@hack> <4B80963D.4030707@shikadi.net>
Date: Sun, 21 Feb 2010 10:15:01 +0800
Message-ID: <2375c9f91002201815tafcf286ga28337ee37c9dc02@mail.gmail.com>
Subject: Re: UML error - apps killed 50% of the time
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 10:11 AM, Adam Nielsen <a.nielsen@shikadi.net> wrote:
>>> Just more random tasks being killed:
>>> /sbin/functions.sh: line 184:  1098 Killed
>>> /usr/bin/logger -p "${pri}" -t "${tag}" -- "$*"
>>
>> I tested it, it is fixed by the updated patch:
>>
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-02/msg05620.html
>
> That patch won't apply - if I am reading it correctly it looks like it was
> already part of the original patch
> (http://patchwork.kernel.org/patch/79358/)
>

No, they are different. Sorry that the above page mangles the patch,
please try this one:

http://lkml.org/lkml/diff/2010/2/15/61/1

Thanks.
