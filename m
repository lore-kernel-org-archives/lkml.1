Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXCGVDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXCGVDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXCGVDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:03:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:30208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645AbXCGVDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hE49NySPWNPCryLkrJ8Ts/09jJ8lJFNmKbwUdwyIWAuu/qJBYBj6ipjVAElq+jkBPG5Qq5MvA8usrrxR9OjkhmIiFoZ1Jd1c5tRh6AQlAk0aQBwDzViiyHCDcYf9UVfLODUxy427tyvnIKbo/3NThyl2sj9QlB1sHzDJ36Mk/+0=
Message-ID: <75b66ecd0703071303k24799f10ibc5c49dc69c5ee86@mail.gmail.com>
Date: Wed, 7 Mar 2007 16:03:36 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Sleeping thread not receive signal until it wakes up
Cc: "Luong Ngo" <luong.ngo@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1b2aacd80703062131g6c8578fgf200dd05a502c49f@mail.gmail.com>
	 <Pine.LNX.4.61.0703070813070.12338@chaos.analogic.com>
	 <1b2aacd80703071128v5227382do2277d0b85ca3b20c@mail.gmail.com>
	 <Pine.LNX.4.61.0703071457060.13923@chaos.analogic.com>
X-Google-Sender-Auth: cdf97d263f32d4c8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> Interruptible_sleep_on is interruptible, but for your task to
> actually be awakened and your alarm handler to get some CPU,
> it needs to be scheduled. If the BKL (big kernel lock) is
> held, it won't be scheduled until it is released.

You can schedule while holding the BKL and it will be dropped and reacquired.

Lee
