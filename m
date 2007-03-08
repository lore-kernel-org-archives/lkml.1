Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbXCHAkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbXCHAkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCHAkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:40:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:33010 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXCHAkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ks2YpVWxwVF52PnPyVyuBO1mI5ZM9eH/Ny3+Z5L3hE68fwPRMOse32BTRS7Sq4PdNjaww2u0WiWaj9cfW5Qq0Ufb8QxgKoQcCzlGJJqWCrgTllqyueC8JDEYWCyK+km3zrUaNreR05I2dXvA3WcGCm/2ZoDKqfksxE5yehjPWAw=
Message-ID: <1b2aacd80703071640r64557333yfa5c7f69050ed9f8@mail.gmail.com>
Date: Wed, 7 Mar 2007 16:40:13 -0800
From: "Luong Ngo" <luong.ngo@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <75b66ecd0703071303k24799f10ibc5c49dc69c5ee86@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
	 <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
	 <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
	 <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
	 <75b66ecd0703071303k24799f10ibc5c49dc69c5ee86@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Lee Revell <rlrevell@joe-job.com> wrote:
> On 3/7/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> > Interruptible_sleep_on is interruptible, but for your task to
> > actually be awakened and your alarm handler to get some CPU,
> > it needs to be scheduled. If the BKL (big kernel lock) is
> > held, it won't be scheduled until it is released.
>
> You can schedule while holding the BKL and it will be dropped and reacquired.
>
> Lee
>


My hardware is PowerPC architecture. Does it have any thing to do with
the kernel locking? Also, I saw CONFIG_LOCK_KERNEL,
CONFIG_PREEMPT_BKL ans CONFIG_SMP in the file
include/linux/smp_lock.h, or CONFIG_PREEMPT  in lib/kernel_lock.c and
I don't have any of these macro defined, would that be the reason. I
could not find where these option when running make menuconfig either.


Thanks,
LNgo
