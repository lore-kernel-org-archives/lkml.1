Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZJVN50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZJVN50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZJVN5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:57:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39712 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZJVN5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:57:24 -0400
Date: Thu, 22 Oct 2009 06:57:22 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: mtk.manpages@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Helsley <matthltc@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091022135722.GH7757@count0.beaverton.ibm.com>
References: <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com> <20091019235012.GF27627@count0.beaverton.ibm.com> <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com> <4ADF06B7.50508@zytor.com> <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com> <4AE0444B.5070603@zytor.com> <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0910220514y1bd5967aj3a04bc3f5b38948b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 02:14:16PM +0200, Michael Kerrisk wrote:
> Peter,
> 
> On Thu, Oct 22, 2009 at 1:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 10/22/2009 07:26 PM, Michael Kerrisk wrote:
> >>>
> >>> "3" is number of arguments.
> >>
> >> sys_clone3(struct clone_struct __user *ucs, pid_t __user *pids)
> >>
> >> It appears to me that the number of arguments is 2.
> >>
> >
> > It was 3 at one point... I'm not sure when that changed last :-/
> >
> >>> It's better than "extended" or something like
> >>> that simply because "extended" just means "more than", and a number at
> >>> least
> >>> tells you *how much more than*.
> >>
> >> I'm not sure why you think including a number in the name tells us
> >> "how much more than". Unless you are considering the numbering to be
> >> version numbers, which apparently is not what you mean.
> >
> > It is a version number of sorts.
> 
> So, sometimes, a number in a system call should be the bit width of
> some arguments(s), sometimes it should be the number of arguments, and
> sometimes (well, just occasionally, as in mmap2() and clone()) -- it
> should be a version number? Does the weather play any part in the

In this case 3 could be both the number of arguments and the version
number (clone, clone2, clone3). Match 2 conventions with one choice of
name. :)

Cheers,
	-Matt Helsley
