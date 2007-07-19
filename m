Return-Path: <linux-kernel-owner+w=401wt.eu-S939092AbXGSOOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939092AbXGSOOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965221AbXGSOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:08:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:31814 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215AbXGSOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gqVVqKvz5t0Anauo0MnwbS0zjGs5fMmzdpSGoHRt37Gkfk1U1l1PjaDJZjJmr3/51WWiLAySuDETneEfdT8Z/8nQJIdkUrMuJMTKBbK0pva5mtRZE3itu+wRcUuUFTTXzafvwXrhzeq1ValFrnhMLPxisdReWmqDv2c1ZpViMWQ=
Message-ID: <84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
Date: Thu, 19 Jul 2007 17:08:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: kmalloc zero size changes break i386
Cc: "Christoph Lameter" <clameter@sgi.com>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707191201.35777.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191201.35777.ak@suse.de>
X-Google-Sender-Auth: 8174b5c92eafac01
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
> qemu testing and booting test machines with i386 kernels wasn't very successfull
> with recent git kernels. I got either BUGs because of failing sysfs initialization
> or oopses in kmalloc, but no user land.
>
> I bisected it down to this commit.
>
> To reproduce: try to boot a 386 defconfig kernel, compiled with gcc 4.1, in qemu

[snip]

> 6cb8f91320d3e720351c21741da795fed580b21b is first bad commit
> commit 6cb8f91320d3e720351c21741da795fed580b21b
> Author: Christoph Lameter <clameter@sgi.com>
> Date:   Tue Jul 17 04:03:22 2007 -0700
>
>     Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics

I have i386 defconfig kernel + qemu + busybox userland image + GCC
4.1.2 booting ok here. Did you manage to capture the oops? Is the
userland image available somewhere?

                                             Pekka
