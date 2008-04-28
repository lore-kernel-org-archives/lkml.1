Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbYD1AeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbYD1AeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYD1Adx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:33:53 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:22907 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751002AbYD1Adw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FUF4VLysrGC+lhCYALlnqcdFRC76Tolr2U+Zf5PJWU6C5MCiDyttiO0fXvKOerVi3bMA/GpdAMpjMIyPGrAuV/ud3pd1m/LfH2sB12YeBxkMh3Yzyz6ge25faB3ulbbpBB/fcPPSWwhI+9lAWcsnV/+S2uOw9ZKMtZChJ0kAgyM=
Message-ID: <86802c440804271733o1ec17f7aye04216ce28347435@mail.gmail.com>
Date: Sun, 27 Apr 2008 17:33:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <87hcdmnccu.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426185516.GA32364@elte.hu>
	 <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
	 <20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 3:48 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi Ingo,
>
>
>  Ingo Molnar <mingo@elte.hu> writes:
>
>  > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>  >
>  >> IOW, they'd be big enough that people hopefully don't start nitpicking
>  >> about some *totally* uninteresting small detail, but small enough that
>  >> people can read it through without losing concentration about a
>  >> quarter of the way in.
>  >
>  > ok. Here's the "memory management" type of changes:
>  >
>  >    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootmem.git for-linus
>  >
>  > the other sub-trees will depend on these changes. I think these
>  > infrastructure and other improvements are mergable and pullable as-is.
>  >
>  >       Ingo
>  >
>  > ------------------>
>
>  [...]
>
>
>  >       mm: allow reserve_bootmem() cross nodes
>
>  I find it sad that this goes in now.  I wrote a clean version of
>  reserve_bootmem() [1] and it was rejected with arguments that I did not
>  understand [2] and that were not further explained even though I asked
>  for it [3].
>
>  http://lkml.org/lkml/2008/4/16/76
>  http://lkml.org/lkml/2008/4/16/234
>  http://lkml.org/lkml/2008/4/16/250
>
>  Your comment was rather unfair, because it gave the impression you did
>  not read the thread before replying.  And you did not react to other
>  explicit questions from me.  If you find my patches to be crap, say so
>  and please explain WHY so I have a chance to improve.

this thread is for reserve_bootmem ?

You patch is regarding to free_bootmem, and it doesn't work with intel
cross node boxes.

YH
