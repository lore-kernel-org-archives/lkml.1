Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXKTAkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXKTAkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXKTAkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:40:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbXKTAkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:40:12 -0500
Date: Mon, 19 Nov 2007 16:39:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] Fix missing closing parenthesis in binfmt_elf.c
Message-Id: <20071119163936.986394dd.akpm@linux-foundation.org>
In-Reply-To: <47422754.9090802@gmail.com>
References: <47422754.9090802@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 20:16:20 -0400
Kevin Winchester <kjwinchester@gmail.com> wrote:

> 
> An obviously missing closing parenthesis.
> 

I'm going through complete misery with that file.

> 
> ---
> 
> This is more for practice sending patches than anything else, to make
> sure they are not damaged in any way.
> 
> But it does bring up a good question.  Are patches expected/wanted for
> the mmotm kernels?

Sure, thanks.

> Index: linux-mm/fs/binfmt_elf.c
> ===================================================================
> --- linux-mm.orig/fs/binfmt_elf.c       2007-11-19 20:01:00.000000000 -0400
> +++ linux-mm/fs/binfmt_elf.c    2007-11-19 20:02:34.000000000 -0400
> @@ -1031,7 +1031,7 @@
>         }
> 
>         if (elf_interpreter) {
> -               if (IS_AOUT_INTERP(interpreter_type) {
> +               if (IS_AOUT_INTERP(interpreter_type)) {
>                         elf_entry = load_aout_interp(&loc->interp_ex,
>                                                      interpreter);
>                 } else {
