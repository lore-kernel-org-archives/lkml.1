Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZIICzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZIICzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZIICzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:55:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54862 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZIICzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:55:09 -0400
Date: Wed, 9 Sep 2009 11:55:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 2/5] Use new __init_task_data macro in arch init_task.c files.
Message-ID: <20090909025506.GB23049@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@ksplice.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>, Joe Perches <joe@perches.com>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com> <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252464546-26394-3-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 10:49:03PM -0400, Tim Abbott wrote:
> From: Joe Perches <joe@perches.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> 
> ---
>  arch/arm/kernel/init_task.c            |    5 ++---
>  arch/avr32/kernel/init_task.c          |    5 ++---
>  arch/cris/kernel/process.c             |    5 ++---
>  arch/frv/kernel/init_task.c            |    5 ++---
>  arch/h8300/kernel/init_task.c          |    5 ++---
>  arch/ia64/kernel/init_task.c           |    3 ++-
>  arch/m32r/kernel/init_task.c           |    5 ++---
>  arch/m68k/kernel/process.c             |    6 +++---
>  arch/m68knommu/kernel/init_task.c      |    5 ++---
>  arch/microblaze/kernel/init_task.c     |    5 ++---
>  arch/mips/kernel/init_task.c           |    5 ++---
>  arch/mn10300/kernel/init_task.c        |    5 ++---
>  arch/parisc/kernel/init_task.c         |    4 ++--
>  arch/powerpc/kernel/init_task.c        |    5 ++---
>  arch/powerpc/kernel/machine_kexec_64.c |    5 +++--
>  arch/s390/kernel/init_task.c           |    5 ++---
>  arch/sh/kernel/init_task.c             |    5 ++---
>  arch/sparc/kernel/init_task.c          |    5 ++---
>  arch/um/kernel/init_task.c             |    5 ++---
>  arch/x86/kernel/init_task.c            |    5 ++---
>  arch/xtensa/kernel/init_task.c         |    5 ++---
>  21 files changed, 44 insertions(+), 59 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
