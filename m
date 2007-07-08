Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbXGHE4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbXGHE4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 00:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXGHE4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 00:56:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61917 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXGHE4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 00:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZgtxlJu1yBJIMIF6lZxtnxmT+ygDdOlgg07sOvW9fyPJ9QFkgthmg/amkEmbTq4B+WNgJAJ7QUmNyW1wgvH35w/Q+F2GRm+tbN1BekwQas9IuELzT96ENC6a1HC7JN6/QJaErs1wUmtPPqllvLgJ5iVfGXpPykaAS5s5WNn7/O8=
Message-ID: <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>
Date: Sat, 7 Jul 2007 21:56:06 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
Cc: "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <469038EF.7040709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>
	 <20070703094916.e60d4df7.akpm@linux-foundation.org>
	 <468B3CFF.7020903@gmail.com>
	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>
	 <468C9E74.4080606@gmail.com>
	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>
	 <468F36F5.4010803@gmail.com>
	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>
	 <469038EF.7040709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/07, Tejun Heo <htejun@gmail.com> wrote:
> Miles Lane wrote:
> >> Weird, that's unrelated path.  It seems sd->s_parent is NULL in
> >> sysfs_link_sibling(), which doesn't make sense because it's being called
> >> from sysfs_create_link() which makes sure parent_sd isn't NULL &&
> >> sysfs_addrm_start() should have caused oops earlier as it deferences
> >> parent_sd.
> >>
> >> Can you please retry the test (test clean 2.6.22-rc6-mm1, apply patch,
> >> rebuild and test)?
> >
> > I downloaded linux-2.6.22-rc6.tar.bz2, applied 2.6.22-rc6-mm1 and then
> > applied your second patch.  I still get the same OOPS I reported to you
> > and Andrew in the image I attached to my previous message.
>
> Thanks a lot.  Just in case, if you remove the patch (patch -R -p1), the
> oops goes away, right?

I double-checked.  I can boot fine after building without your patch.
Also, I reproduced the initial BUG I reported (triggered by
"modprobe -r ipw2200").

     Miles
