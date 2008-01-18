Return-Path: <linux-kernel-owner+w=401wt.eu-S1754407AbYARG7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbYARG7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbYARG7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:59:36 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:50219 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750853AbYARG7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aFPriXfyVzZlSaKCzAN2eV4syWOyMrvAQVi6KJvRCVu8eFBB9pIHqQvV1LIohe4QwGEmO9Knrh9dG9h82WVyZWtctfJHMuqyg1QX2PocSGM36qUTx5uLdOouU2lZApQE85PIi1qz37rLzUuTHm5zL7DOWiuILKnbPZ5mDtGZYNc=
Message-ID: <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
Date: Fri, 18 Jan 2008 14:59:32 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Zan Lynx" <zlynx@acm.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200801180640.m0I6enPI029212@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
	 <20080117181935.02294863.akpm@linux-foundation.org>
	 <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
	 <20080117204247.5318e500.akpm@linux-foundation.org>
	 <200801180640.m0I6enPI029212@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 2:40 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Hello.
>
> Andrew Morton wrote:
> > It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> > were you and Zan using please?

I have the same problem, gcc 3.4.6

>
> I'm using gcc 3.3.5 on Debian/Sarge .
>
> By the way, 2.6.24-rc8-mm1 doesn't hang with a kernel config
>
> # make -s allnoconfig
> # make -s menuconfig
>
>   Set [*] to all entries in "Kernel hacking  --->" section
>   (except "KGDB: kernel debugging with remote gdb").
>
> # make -s && make -s install
>
> Regards.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
