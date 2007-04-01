Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXDAGqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXDAGqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXDAGqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:46:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2820 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932819AbXDAGqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LkIDzw6XeyDhyaHVH3uYNPsQEtTHwkMSbty1dl8U0oVlg8or8Pe/c9XDS/Uqi9epPTius2lneN92dAl1W3ORdBttY9cmsjCLuAINjtcwTb0Ktluu418hzoHw3oUcR3n/seBNwDanx/bEdqodWBnn2MrWzPOfKhGoPa5NyVm/Lc8=
Message-ID: <2375c9f90703312346t5cf9f85x7f2a13df6cfa1d6d@mail.gmail.com>
Date: Sun, 1 Apr 2007 14:46:50 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm3 patch]Warning fix: check the return value of kobject_add etc.
Cc: viro@zeniv.linux.org.uk
In-Reply-To: <20070331233422.f171ff4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2375c9f90703301930k4963168u4ba4dbc4c43ce2ee@mail.gmail.com>
	 <20070331223136.6019d98f.akpm@linux-foundation.org>
	 <2375c9f90703312320m3e895bbap735c2d49da9d5ff9@mail.gmail.com>
	 <20070331233422.f171ff4c.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/1, Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 1 Apr 2007 14:20:46 +0800 "Cong WANG" <xiyou.wangcong@gmail.com> wrote:
>
> >
> > >
> > > Also, please always prepare patches in `patch -p1' form, as per
> > > http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, thanks.
> > >
> > >
> >
> > Sorry. I am confused with this. Does that mean I should make patches
> > _upon_ the root kernel source directory or first make a copy of the
> > original source code and then diff against the two dirs? But I was
> > told that "patches should be based _in_ the root kernel source
> > directory" and when only one file was modified just to diff it with
> > the original single file. (See Documentation/SubmittingPatches.)
>
> The headers should look like:
>
> --- a/arch/cris/kernel/crisksyms.c
> +++ a/arch/cris/kernel/crisksyms.c
>
> I don't know how people do that.  One obvious way is to do
>
> cd /usr/src
> diff -u linux-orig/arch/cris/kernel/crisksyms.c linux-new/arch/cris/kernel/crisksyms.c
>
> other people probably alter the diff headers.

Oh, thanks. I know.

>
> > And should I remake this patch?
>
> Sure, but please change it to perform correct error handling first.  And
> test that error handling, if you can.  That will involve adding artificial
> errors.
>

I will remake it soon and send it again.

In fact, I have just tested it roughly. And I don't how to produce
artificial errors. Sorry, I hope someone can help me to test it
carefully.
