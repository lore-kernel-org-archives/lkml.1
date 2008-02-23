Return-Path: <linux-kernel-owner+w=401wt.eu-S1765280AbYBWI7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765280AbYBWI7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYBWI7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:59:00 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:55506 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYBWI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rQtFR9uGxGUB90wvEyp6wt6ifOTrH72lH3xRdahZAIknqcvELYl6CfVLFM3R9jdbjV5+4exz/6+37h2jhovXfHVAmpYO1ajV6NMmTfMzVu+1SNHw4P98IQgf5koTgdXRRov4KLFVUDGGurQeYBZgmXU1vpGV7RUquYaB+qB1bKk=
Message-ID: <386072610802230058g5df9ab63pcd55b012ce8740d6@mail.gmail.com>
Date: Sat, 23 Feb 2008 16:58:55 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "WANG Cong" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 01/16] Make the macro get_personality function-like.
Cc: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "David Howells" <dhowells@redhat.com>
In-Reply-To: <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
	 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
X-Google-Sender-Auth: 1c2fe407826519de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 4:14 PM, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> This patch makes the macro get_personality function-like.
>
>  Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>  Cc: Christoph Hellwig <hch@infradead.org>
>  Cc: Bryan Wu <bryan.wu@analog.com>
>  Cc: David Howells <dhowells@redhat.com>
>
>  ---
>   arch/blackfin/kernel/signal.c |    2 +-
>   arch/frv/kernel/signal.c      |    4 ++--
>   include/linux/personality.h   |    2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
>
>  diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
>  index 5564c95..f3ef4ee 100644
>  --- a/arch/blackfin/kernel/signal.c
>  +++ b/arch/blackfin/kernel/signal.c
>  @@ -224,7 +224,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
>
>         /* Set up registers for signal handler */
>         wrusp((unsigned long)frame);
>  -       if (get_personality & FDPIC_FUNCPTRS) {
>  +       if (get_personality() & FDPIC_FUNCPTRS) {
>                 struct fdpic_func_descriptor __user *funcptr =
>                         (struct fdpic_func_descriptor *) ka->sa.sa_handler;
>                 __get_user(regs->pc, &funcptr->text);

It looks ok for Blackfin

Acked-by: Bryan Wu <cooloney@kernel.org>

Thanks a lot.
