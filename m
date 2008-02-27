Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYB0WAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYB0WAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbYB0WAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:00:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:46403 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbYB0WAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fQOiRHwTByLNDwBVQYfHIs5vtEX13XrAuE9uJHswY+cDlgF/NeP0sRkLy0oK/NypoQBSEcCi7VnLdsMPbLUmXaQFj5quA8qLRq4EUjh0MfQl6MfbM8sk7/886tYK7/Q/cJHtThJtpfhqqkpjRPtPoyRbF1kmIsWv+X7rWxGactM=
Message-ID: <86802c440802271400k5e981d40vfd278c07c6bf04f5@mail.gmail.com>
Date: Wed, 27 Feb 2008 14:00:01 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: X86_HT always enable on X86_64 SMP
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Sam Ravnborg" <sam@ravnborg.org>, linux-kernel@vger.kernel.org
In-Reply-To: <47C5D693.3030207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C5D32E.8070308@ct.jp.nec.com>
	 <20080227212658.GU29269@cs181133002.pp.htv.fi>
	 <47C5D693.3030207@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 1:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Adrian Bunk wrote:
>  > On Wed, Feb 27, 2008 at 01:16:30PM -0800, Hiroshi Shimamoto wrote:
>  >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>  >>
>  >> X86_HT is used for hyperthreading or multicore on 32-bit.
>  >> The X86_HT on 64-bit is different from 32-bit, it means hyperthreading only.
>  >> And X86_HT is not used on 64-bit except from cpu/initel_cacheinfo.c.
>  >>
>  >> Unify X86_HT for hyperthreading or multicore.
>  >> Turn X86_HT on when X86_64 and SMP are enabled.
>  >
>  > Please fix it properly instead - fiddling around with it the way you do
>  > only asks for trouble in the future.
>  >
>  > What we need are two different variables for:
>  > - hyperthreading and
>  > - multicore
>  >
>
>  He does, and calls them SCHED_SMT and SCHED_MC respectively.
>
>  It's not particularly clear to me what X86_HT is meant to be used for
>  anymore at all.

he made X86_HT can be enabled when only Opteron supported is enabled.

it should be stated in the comments.
YH
