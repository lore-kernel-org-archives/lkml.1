Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbXCRAhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbXCRAhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCRAhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:37:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1761 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXCRAhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Y6NSZaA+l51oCmYxQhdDdHsTBu9r96T0Ybz+Nk8lwhBrVoeCrQWKjAOP+4bIsLvnkAe+bzQC4itkHB3iZiRTATPiW/6FOdoAlfGrU7OqG64svLPHY3oAtlRa7wBFSB/mKHsZ2QtLUpk4wzvCoElqIfwpwsbXp0svo+KkFHUkppM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE fixes
Date: Sun, 18 Mar 2007 01:44:58 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200703172207.52352.bzolnier@gmail.com> <Pine.LNX.4.64.0703171702060.4964@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703171702060.4964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703180144.58509.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 18 March 2007, Linus Torvalds wrote:
> 
> On Sat, 17 Mar 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > to receive the following updates:
> > 
> >  b/drivers/ide/Kconfig                       |   48 -
> >  b/drivers/ide/Makefile                      |    1 
> >  b/drivers/ide/arm/icside.c                  |   13 
> >  b/drivers/ide/ide-dma.c                     |    2 
> >  b/drivers/ide/ide.c                         |    4 
> >  b/drivers/ide/mips/au1xxx-ide.c             |    3 
> >  b/drivers/ide/pci/Makefile                  |    1 
> >  b/drivers/ide/pci/cmd64x.c                  |   45 -
> >  b/drivers/ide/pci/jmicron.c                 |   29 
> >  b/drivers/ide/pci/scc_pata.c                |  858 ++++++++++++++++++++++++++++
> >  b/drivers/ide/setup-pci.c                   |    5 
> >  b/include/asm-mips/mach-au1x00/au1xxx_ide.h |   34 -
> >  drivers/ide/ppc/scc_pata.c                  |  858 ----------------------------
> >  13 files changed, 915 insertions(+), 986 deletions(-)
> 
> Please use
> 
> 	git diff -M --stat --summary 
> 
> to generate the diffstat (where the "-M" is the important part). Your 
> "scc_pata.c" change was a pure rename, but because you didn't ask for 
> rename detection, it got shown as a file create/delete pair. It *should* 
> have looked like this:
> 
>  drivers/ide/Kconfig                       |   48 +++++------------------------
>  drivers/ide/Makefile                      |    1 -
>  drivers/ide/arm/icside.c                  |   13 +-------
>  drivers/ide/ide-dma.c                     |    2 +-
>  drivers/ide/ide.c                         |    4 --
>  drivers/ide/mips/au1xxx-ide.c             |    3 +-
>  drivers/ide/pci/Makefile                  |    1 +
>  drivers/ide/pci/cmd64x.c                  |   45 ++++++++++++---------------
>  drivers/ide/pci/jmicron.c                 |   29 ++++++++++++++---
>  drivers/ide/{ppc => pci}/scc_pata.c       |    0
>  drivers/ide/setup-pci.c                   |    5 ---
>  include/asm-mips/mach-au1x00/au1xxx_ide.h |   34 --------------------
>  12 files changed, 57 insertions(+), 128 deletions(-)
>  rename drivers/ide/{ppc => pci}/scc_pata.c (100%)
> 
> which is a lot more accurate than what you get by feeding a diff through 
> "diffstat" that has no clue about renames (look at the summary for number 
> of lines changed ;)

Thanks, I updated my scripts and also a git version installed while at it.

[ I was feeling that I was missing something but these options were
  undocumented in git-1.4.4.2, no longer a case in git-1.5.0.3. :-) ]

Bart
