Return-Path: <linux-kernel-owner+w=401wt.eu-S1765156AbXGZGu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765156AbXGZGu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764275AbXGZGuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:50:40 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:61116 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763319AbXGZGuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hq2dEJ0vBnAfYqUacmiZqPzslYjJGagYJflvDQ3svcVddPgT/tLUwZOztZMnXlKAu5yzN84OLqvYHlKpuVb2FsKFuxaREz72XgqQ7CnqZSsBzXF+lXnWCd2mFMYJvEEYuduOPz/Mkkyi8LGZJmdRdEYBpuDhr0ZAR2osyxKD9ds=
Message-ID: <4104961b0707252350g163dc133r420422dd4dde40f2@mail.gmail.com>
Date: Thu, 26 Jul 2007 14:50:38 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: What's does KPROBE_ENTRY mean?
In-Reply-To: <20070726061117.GA25926@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0706202213p16df5ca5s579de4b949efbf16@mail.gmail.com>
	 <4104961b0707252243l41addce8wca35d19c5de729ee@mail.gmail.com>
	 <20070726061117.GA25926@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.So if I don't care any probes, and I actually don't need to
take use of kprobes, then I can use the functions defined through
KPROBE_ENTRY() the same way as those defined via ENTRY(), right?

Regards
Jason Xiao

On 7/26/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Jul 26, 2007 at 01:43:10PM +0800, jidong xiao wrote:
> > Anyone can help this?
> >
> > On 6/21/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> > > I searched in linux kernel 2.6.10, didn't find it, then I tried
> > > 2.6.20, it is there. But I am not familiar with assembly language, so
> > > can anybody kindly explain it, I don't know the difference between
> > > KPROBE_ENTRY and ENTRY, however, I can find both of these items in
> > > some files, such as arch/x86_64/kernel/entry.S.
> > >
> KPROBE_ENTRY() is the assembly equivalent of __kprobes, it places the
> symbol in a special section (.kprobes.text) where probes can't be
> inserted. This is usually helpful in cases where inserting the probe may
> lead to recursion or other undesirable behaviour.
>
> See include/linux/linkage.h and include/linux/kprobes.h.
>
