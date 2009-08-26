Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZHZVdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZHZVdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbZHZVdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:33:04 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:55570 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZHZVdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:33:02 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 17:33:01 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=upBLTjamxIKXvo8SM5CrXXsBpxMvKu/4KYKfKsXFgyDgb+jt5cRqtADZJyQ07W3ZX2
         o2jyDC2QDduK65XQ73+2Bu9PEd3qm6R+XkPC9EudW4V3SJKLaHbqsSj5RTQH24UONPV6
         Zh+jojhn5mTwYlramlgP7r2oJYkT1MgpvEHYg=
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 23:26:33 +0200
X-Google-Sender-Auth: f1efd97ce07deef6
Message-ID: <10f740e80908261426w4c37f960ma9ff1206a65618d4@mail.gmail.com>
Subject: [git pull] m68k updates for 2.6.31 (was: Re: [git pull] m68knommu 
	arch fixes)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jun 12, 2009 at 08:22, Geert Uytterhoeven<geert@linux-m68k.org> wrote:
> Probably I won't have time to handle and submit any m68k patches
> during this merge window,
> so if anyone needs anything to be in 2.6.31, it would be nice if
> somebody else could take care of
> it.

Here is the most critical stuff. Thanks for pulling!

The following changes since commit f415c413f458837bd0c27086b79aca889f9435e4:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git#for-linus

Alexey Dobriyan (1):
      m68k: Fix redefinition of pgprot_noncached

Andrew Morton (1):
      arch/m68k/include/asm/motorola_pgalloc.h: fix kunmap arg

Geert Uytterhoeven (1):
      m68k,m68knommu: Wire up rt_tgsigqueueinfo and perf_counter_open

Roel Kluin (2):
      m68k: count can reach 51, not 50
      m68k: cnt reaches -1, not 0

 arch/m68k/amiga/config.c                 |    6 ++++--
 arch/m68k/include/asm/motorola_pgalloc.h |   10 ++++------
 arch/m68k/include/asm/pgtable_mm.h       |    3 +--
 arch/m68k/include/asm/unistd.h           |    4 +++-
 arch/m68k/kernel/entry.S                 |    2 ++
 arch/m68knommu/kernel/syscalltable.S     |    2 ++
 drivers/macintosh/via-maciisi.c          |    2 +-
 7 files changed, 17 insertions(+), 12 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
