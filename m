Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbXDBBDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbXDBBDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 21:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXDBBDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 21:03:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:37747 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXDBBDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 21:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lAjKEWpEnm0cihC7Qlw0hEgDOTurntLkvpiDOjOCig1wq3d58RtM7fPDJx3Eby1ZxDO2/ryQYeGShsSIKKPN/NB/cWREdfve2ZDp6IzEa6GtLki2pmPg55nXeph7G5+oBEd7/xSsmIPFa/dWRTvNTJYqeFMr8t5VrPpEOEJPn00=
Message-ID: <478c16ae0704011803ub1d401xfd7fb2bda61a9f39@mail.gmail.com>
Date: Sun, 1 Apr 2007 22:03:21 -0300
From: "Edgardo Hames" <ehames@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Rebuilding and checksumming the Linux kernel
In-Reply-To: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 1, 6:10 pm, "David Schwartz"  wrote:
> > I'm working on a project with teams spread across the world and we all
> > work on the same repository patching the kernel and then integrating
> > into a common main branch. Even though we label the source code, we
> > would like to make sure that we are all building the same kernel by
> > running md5sum on the resulting binary.
> > Right now, this is not possible because the kernel includes a
> > timestamp and a build number on the binary. What are this timestamps
> > used for? Can we just remove them? Is there any other thing that may
> > lead to different binaries? (we are using the exact toolchains and
> > build machines, so we can assume that the same executable is generated
> > if the input source is the same).
>
> I think this is wrong in principle even if you can get it to work in
> practice. If you want to all work on the same kernel, then keep a single
> copy somewhere that you all work from. There is no reason the same source
> code will or should always produce the same output. Compilers are not
> generally required to be deterministic.

Could you please be a little more specific? We keep toolchains in our
SCM tool, so we can always retrieve a particular version of them and
rebuild with them. Why shouldn't we get the same binary then? I'm
really interested in hearing your opinion on this practice.

Thanks,
Ed
-- 
Encontrá a "Tu psicópata favorito" http://tuxmaniac.blogspot.com

The future is not what it used to be.
-- Paul Valéry
