Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZDOAWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZDOAWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZDOAWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:22:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45199 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDOAWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jm2JDCuc4KYAB0jPFRJiAnirC38SACgBoTpIRrtTJRbrYydxlZYt1Kp+H+SJ7siQlG
         BXXosFfJKSwDOUgHzWbJKMPUZpV6oqVVJnoBf2DZrwtX/6w0ZYwsvMvPdsNI8flI+FfT
         JWn8zl1mLie3IC0azs4D3QzH8AC2mYznqeF54=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
Date: Wed, 15 Apr 2009 02:22:03 +0200
Message-ID: <5a4c581d0904141722g12e791eha4fa0fb206769ce5@mail.gmail.com>
Subject: Re: Linux 2.6.30-rc2
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 1:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Hmm.
>
> New 'microblaze' architecture, a somewhat late 'input' layer merge, a new
> intel virtual networking driver and some firmware loading updates. And
> mn10300 and frv moved their header files from include/asm to arch. That
> accounts for the bulk, but shouldn't affect anybody.
>
> Otherwise? Some driver updates (ide, infiniband, sgi-xp, intel dri,
> watchdog). nilfs2 and xfs filesystem updates.
>
> And random small fixes. Not all as small as I'd wish for, but it's just
> early -rc2, and it at least feels less chaotic than some other -rc2's. But
> maybe that's my optimistic nature again.
>
> Shortlog appended, it might give people some flavor of the kinds of
> changes there were.
>
>                Linus

[snip]

Takes a few seconds to not build here, with oldconfig as per rc1-git7:

[...]
  LD      init/mounts.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  LD      init/built-in.o
  HOSTCC  usr/gen_init_cpio
  GEN     usr/initramfs_data.cpio
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  CC      arch/x86/kernel/process_64.o
  CC      arch/x86/kernel/signal.o
  AS      arch/x86/kernel/entry_64.o
  CC      arch/x86/kernel/traps.o
arch/x86/kernel/traps.c:57:28: error: asm/mach_traps.h: No such file
or directory
arch/x86/kernel/traps.c: In function ‘default_do_nmi’:
arch/x86/kernel/traps.c:397: error: implicit declaration of function
‘get_nmi_reason’
make[1]: *** [arch/x86/kernel/traps.o] Error 1
make: *** [arch/x86/kernel] Error 2

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
