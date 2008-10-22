Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYJVIj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYJVIj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 04:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYJVIjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 04:39:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYJVIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 04:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Mwr+Fr6VknQUXAdGSR4BeChNegGsgtlb7ZBrZE58Nrb7Rx7KFF33fv6R1UEOlwCn48
         P9c6CBQVdMhgcnDQT9EU9urLrAXvhPk3gETmfV4a23DlBMJ9ITimRizc516oubpOvK6R
         Jfts3XqiNA58pUjvr+IWxqRjltUGg6cFNklHo=
Message-ID: <7c86c4470810220139h49269138g844194bd5db3d5c2@mail.gmail.com>
Date: Wed, 22 Oct 2008 10:39:16 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 00/24] perfmon3: introduction
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081021.212502.41487120.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f8a9a3.0437560a.656a.57c5@mx.google.com>
	 <20081021.212502.41487120.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Wed, Oct 22, 2008 at 6:25 AM, David Miller <davem@davemloft.net> wrote:
> From: eranian@googlemail.com
> Date: Fri, 17 Oct 2008 08:05:07 -0700 (PDT)
>
>> Thanks to all the people who have contributed to this new release.
>
> What about the folks who worked hard on sparc, powerpc, et al. perfmon
> support?  Do they "just lose" for the moment?  :-/
>

I was told to start with something very simple and for the key
architecture, i.e,, X86.
That's what I did.

This is only the first step. I am not satisfied with this either. I do
care about all the other
architectures as well. I do put a significant effort into maintaining
those in the current
perfmon2 and perfmon3 incarnations. That includes SPARC.

Since your first patch, I have made sure SPARC would always compile and have the
same level of functionality as other architectures. Just checkout the
2.6.27 patch on SF.net
for perfmon v2 or the GIT tree for perfmon v3 (perfmon3 branch).

The key thing is to get this basic block into the kernel, then we can
add all the
other architectures. I will not forget about Sparc, Power, MIPS, and IA-64.
In fact, the next step will be to add support for the non-x86 architectures
rather than adding functionality. This will put everybody back to the
same level.


> I'm really disappointed that I did all of the work to make pfmon,
> libpfm, and the kernel bits work with perfmon on sparc and that
> appears to be all for nothing as there is no update for those
> architectures in this new patch set.  So likely I'll have to do it all
> over again.
>

Again, this is not lost, and you will not have to do this again. I will provide
the patchset for SPARC and others. I will simply need help testing this as
I don't own SPARC systems. This applies for pfmon and libpfm as well.


> I definitely do not support this reincarnation, this is the last thing
> I expected to happen.
>

This was not easy to accept for me either. I and many other people
have put a lot of efforts in the current perfmon v2 codebase. Earlier
this year, I was told that I had to start from scratch again because the
patch was too big and too complicated. That's what I did with perfmon v3.
I have addressed all the issues there were raised on LKML, going as far
as making this release not backward compatible with perfmon v2.

> Three weeks of my own work down the drain which I invested (during
> which I put my networking maintainership and other responsibilities to
> the side) in order to help champion this perfmon stuff in the first
> place?

I do appreciate your effort which I find quite exceptional. I give you credits
for the SPARC support in each presentation I do. I do maintain the SPARC
codebase to the best of my abilities. I will not give up on it, same thing with
the other architectures. Each one must benefit from the new features offered
by perfmon and we have proven they can.

In summary, what was posted on LKML is just the first piece. Once this is in,
I will push the patches to add support for the other architectures as well. Your
effort is not lost, your code is still maintained and will be used for the SPARC
patchset. The same applies to other people who have contributed for Power
and MIPS.

As you know, I have been involved with this project for quite some time
now. I have been through many ups and downs trying to get this merged
upstream. So rest assured of my full determination to bring this to the point of
success.

Thanks.
