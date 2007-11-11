Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXKKC3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXKKC3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 21:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbXKKC3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 21:29:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbXKKC3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 21:29:02 -0500
Date: Sat, 10 Nov 2007 18:28:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: patch conflicts (MMOTM "10-Nov-2007 22:46")
Message-Id: <20071110182854.1a08fd57.akpm@linux-foundation.org>
In-Reply-To: <200711110104.lAB14ZCl018085@agora.fsl.cs.sunysb.edu>
References: <200711110104.lAB14ZCl018085@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 20:04:35 -0500 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Andrew,
> 
> I'm using http://userweb.kernel.org/~akpm/mmotm/ timestamped "10-Nov-2007
> 22:46".
> 
> 1. I was getting a bunch of patch conflicts, until I realized that this
>    latest set of patches was to be applied against 2.6.24-rc2 (your mm.patch
>    gave it away :-) The last snapshot was against 2.6.24-rc1.
> 
>    What should be the official way in which people using the above URL know
>    which base to apply it against: is looking at mm.patch OK?

That would work.

It's usually very obvious, because the first patch is `origin.patch'
(Linus's latest tree against his most-recent-release) and there's no way in
which that patch will apply to the wrong tree.

It just happened that the particular series you grabbed had an empty
origin.patch.

>  If so, then
>    I'd like to suggest that you move mm.patch to the very beginning of your
>    series file: that way if the first patch causes a conflict, it'd be a
>    hint to the person to investigate why, and mm.patch is fairly clear about
>    it (moreso than when any other patch will fail to apply).
> 
> 2. A related question: if someone uses the above URL for mm patches, how
>    should they report a unique identifier (ala git-describe)?

umm, OK, I'll put a file in there called stamp-yyyy-mm-dd-hh-mm

> 3. I still have patch conflicts, with this series of patches:
> 
> Applying patch..suppress-aout-library-support-if-config_binfmt_aout.patch
> error: patch failed: arch/m68k/kernel/process.c:316
> error: arch/m68k/kernel/process.c: patch does not apply
> Context reduced to (2/2) to apply fragment at 120
> error: patch failed: fs/binfmt_elf.c:961
> error: fs/binfmt_elf.c: patch does not apply
> error: patch failed: include/linux/Kbuild:17
> error: include/linux/Kbuild: patch does not apply
> 
> I also had to comment out these two due to new or dependent conflicts:
> 
> suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
> make-frame_pointer-default=y.patch

I warned you ;)

> 4. With the above 3 patches not applied, I got a couple of compile errors,
>    which I reported separately.

Yup, thanks, I refreshed it.
