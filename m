Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0BRLSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:18:42 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:37191 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0BRLSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vsljlPOZn+dgjhpfgNCCSlxyswk557oUscJMi0L4B66W1UhJ0zHIdLcSyEe4tR/43X
         wqn5HX42ZksNG4sn9mwvYNm33uFvyS3GXDYz5SZj7FynN/StsTxvVGC/KnH022M+3hv7
         vP4ALqWPBBt1awBT3gmvkSFGv7r+nh6+Ju+r4=
MIME-Version: 1.0
In-Reply-To: <1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> 
	<1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 18 Feb 2010 06:18:20 -0500
Message-ID: <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
>  config USE_GENERIC_SMP_HELPERS
>        bool
>
> +config HAVE_REGS_AND_STACK_ACCESS_API
> +       bool
> +

could you add an appropriate help/comment so arch peeps know what
needs to be implemented before they can select this
-mike
