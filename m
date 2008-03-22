Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYCVGsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYCVGsP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 02:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYCVGsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 02:48:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:13075 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYCVGsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 02:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D6Symcw069CSX7t7w2LjbLOeXnv/BzNYxEX9I7hBBai3/e5TBYtvycudMxF/vFlkEBJPpYf+cS3e2fAcjgqCn+V3A98FX4EKNPkKsV9Ylb48VLMbranI/Xlv5O4UA7c48SXzV88kPilTTNQ5GzilNd4IxHAiGgljCu5xx+ZUNrc=
Message-ID: <86802c440803212348i637d49d5r3393b6d9d2ecb0f4@mail.gmail.com>
Date: Fri, 21 Mar 2008 23:48:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080322054537.GA23796@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080321120313.GD25225@elte.hu> <47E3B335.3020501@zytor.com>
	 <20080321142919.GD31719@elte.hu> <20080322054537.GA23796@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 10:45 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> On Fri, Mar 21, 2008 at 03:29:19PM +0100, Ingo Molnar wrote:
>  >
>  > * H. Peter Anvin <hpa@zytor.com> wrote:
>  >
>  > >> very nice patch! I always thought that this was the proper way to do
>  > >> memtest - and we could in fact also do something like this after SMP
>  > >> bringup, and hit the memory bus via multiple CPUs. [that will need a
>  > >> different enumeration though than e820 maps]
>  > >>
>  > >> one structural observation: please make this unified functionality,
>  > >> so that 32-bit kernels can make use of it too.
>  > >>
>  > >
>  > > Indeed.  Of course, it would also be nice if distros shipped
>  > > bootloader-invoked prekernel test software, like memtest86+, by
>  > > default.
>  >
>  > some do (Fedora for example), but it's still a bit quirky for users to
>  > invoke and it would be nice to see those results in the kernel log as
>  > well and flag possibly flaky systems that way. (add a taint bit, etc.,
>  > etc.)
>
>  It may even make sense to merge in the full memtest86. The code is small
>  (both source and binary) and IIRC it shares a lot of init code with x86.
>  The remaining problem would then be how to maintain its tests up do date.

memtester is another choice, and it is more easy to be merged.

YH
