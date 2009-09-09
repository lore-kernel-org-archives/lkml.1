Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbZIICyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbZIICyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZIICyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:54:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54849 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbZIICyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:54:38 -0400
Date: Wed, 9 Sep 2009 11:54:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH v2 3/5] Use macros for .bss.page_aligned section.
Message-ID: <20090909025435.GA23049@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tim Abbott <tabbott@ksplice.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>
References: <1252464546-26394-1-git-send-email-tabbott@ksplice.com> <1252464546-26394-4-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252464546-26394-4-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 10:49:04PM -0400, Tim Abbott wrote:
> This patch changes the remaining direct references to
> .bss.page_aligned in C and assembly code to use the macros in
> include/linux/linkage.h.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/sh/kernel/irq.c      |    6 ++----
>  arch/x86/kernel/head_32.S |    2 +-
>  arch/x86/kernel/head_64.S |    2 +-
>  arch/xtensa/kernel/head.S |    2 +-
>  4 files changed, 5 insertions(+), 7 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
