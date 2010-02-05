Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0BEAn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:43:58 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:56233 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0BEAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:43:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AlS9MlpC2m6WXleVh0X42aAlpaOnFqQWS+BpEzHHoNgCimjN8qsnINLsyGZ9nT8kcR
         I7mS+RSQMtBreQ8WdcDa/BVMp5xeFYLwrc/JzaUCRXBIpzPsGR8VaT/mfS5GjnPU2x0q
         Fxe7pwtD/E0K2a0xbQ8o4l0kREnUO5DoIseFM=
MIME-Version: 1.0
In-Reply-To: <21d7e9971002041314yf8c55p4a7cb638efa0d24a@mail.gmail.com>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
	 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
	 <20100202081727.GA6788@elte.hu>
	 <alpine.DEB.2.00.1002020824001.20769@skynet.skynet.ie>
	 <20100202154450.GC27314@elte.hu>
	 <21d7e9971002041239i5e842698pd8a775f833fc5d51@mail.gmail.com>
	 <20100204204655.GA19050@elte.hu>
	 <21d7e9971002041314yf8c55p4a7cb638efa0d24a@mail.gmail.com>
Date: Fri, 5 Feb 2010 10:43:56 +1000
Message-ID: <21d7e9971002041643i1f6a122fk517abb308606b548@mail.gmail.com>
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off 
	switch out of staging."
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> These were random configs - the size doesnt match an allyesconfig, those are
>> way bigger. My above comment related to the first crash, and to my argument
>> that all other drivers are fine during bootup - and there's a lot of them.
>>
>>> So do you have something you are running after allyesconfig to fix things?
>>> or have you just got a config that is close enough to allyesconfig.
>>>
>>> I'm building kernels with your .config now and boot testing them on the
>>> full range of hardware I have/
>>
>> Thanks. Is there something i can enable to get a better log for you to find
>> out where (and why) it's hanging? It's still early during bootup so the box
>> is not particularly debuggable - so i'm not sure i can get a task list dump,
>> etc., unfortunately.
>>
> Do you have NMI watchdog enabled? (does it work that early)
>
> a backtrace of where it hangs would be nice,
>
> Also a dmesg from booting with drm.debug=15 might help narrow it down
> also.
>

Okay I've booted this on the rv370 + rv380 machines I have, I've no old Athlon's
though so I'm trying to get RHTS to give me access to one or two internally,

Another question, that came to mind, what is there any monitors plugged in?
or a KVM or something? if yes can you try without and if no can you try with?

Also can you add CONFIG_FRAMEBUFFER_CONSOLE as well since I
don't think we test often without it.

Dave.
