Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYAYR1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYAYR1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYAYR1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:27:40 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:22437 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYAYR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Uf86KdOS2I7PFvCwYTB7MIV3DHILlp/Smc5dFBVcl1HZ3uVf8RoZ/AQ1wCT18iSLG85MWaZsFSMg8r3WvVo3Zp22FBzDnTrz+F5krJ/xTNVjYy1wUVItqkRn3DGLumEnN2/5saO9hpS/uFnj6UyWvJGu7MgKrX8TYICugQhW6U4=
Message-ID: <3d8471ca0801250927r67d0a27es77f4176f89e7d8f7@mail.gmail.com>
Date: Fri, 25 Jan 2008 18:27:37 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Dropping some patches from sched-devel
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080125165837.GA19377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801250838h2d1f21f2n95c70bc26e28d310@mail.gmail.com>
	 <20080125165837.GA19377@elte.hu>
X-Google-Sender-Auth: ca25212462aa0491
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 5:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
> sure, done.

Thanks.

> what method are you using of determining quality?

I was talking about code quality: adding a dependency on jiffies does
not seems like a good idea. But also, about the clock quality, I was
focusing on getting rid of underflows and overflows so relaxed the
checks. But I realized all these underflows are definitely needed. I
mean, the conversion from TSC to sched_clock always rounds to lower,
so overtime it lags a bit.

> Could you perhaps try
> to automate it? (even better would be some self-test within the kernel
> that detects badness)

I find the overflow/underflow/warps checks you added in the first
place to be sufficent. Not sure we want to add more tests to
differentiate between normal and abnormal drifts.

Thanks for your prompt reply.

-- 
Guillaume
