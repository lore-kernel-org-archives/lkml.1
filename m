Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXGLIZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXGLIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 04:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXGLIZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 04:25:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:48519 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXGLIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 04:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPs0oWHo1YolWgIZvkJZtN2qMo0J5P83w3KIIHAN5jkBXMTXAB+pWPo4cG+zSYYEUfxFM0gyuCjflbdf/mz9uO7VGqZ7QAMQelZkSEN0cHqLtAJHApQFTSS2M3HFUmn1QrrdiZ9Mn4ypWzU2MyfJrVolFfL3SAsDxxXIl5LN1Bs=
Message-ID: <a44ae5cd0707120125u4c17020bvc9a3a28a24ef042a@mail.gmail.com>
Date: Thu, 12 Jul 2007 01:25:13 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejunu@gmail.com>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46959A2C.7090908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>
	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>
	 <468F36F5.4010803@gmail.com>
	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>
	 <469038EF.7040709@gmail.com>
	 <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>
	 <469484E1.6040000@gmail.com> <4694A769.7040502@gmail.com>
	 <a44ae5cd0707111539l5e5adc4ct76ae2f4cb9063e58@mail.gmail.com>
	 <46959A2C.7090908@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

I tried 2.6.22-rc6-mm1 + your latest patch, and it failed to boot.
Unfortunately, the machine limped along and am unable to capture
the initial BUG or OOPS.  I'll try to get a serial connection set up for
debugging tomorrow, but I am very busy with other stuff.  It would be
great if you could test your own build with the .config file I initially sent
to you for the original BUG: issue.  If you would like me to resend the
.config, just let me know.

      Miles


On 7/11/07, Tejun Heo <htejun@gmail.com> wrote:
> Miles Lane wrote:
> > Does this patch replace or add to the last patch you sent me?
> > I'll try applying them with --dry-run and assume that if #1 + #2
> > doesn't apply cleanly, then you only want me to test with this
> > latest patch.
>
> This replaces the old one.  Just revert the old one and apply this one.
>
> > I'll be able to test this later this evening.  I've had house guests and
> > so haven't been available the last few days.
>
> Yeap, I'll wait for the result.  Thanks a lot.
>
> --
> tejun
>
