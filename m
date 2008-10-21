Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYJUUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYJUUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbYJUUPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:15:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYJUUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:15:42 -0400
Date: Tue, 21 Oct 2008 13:15:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, paulmck@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] byteorder: remove direct includes of
 linux/byteorder/swab[b].h
Message-Id: <20081021131534.7c084fdb.akpm@linux-foundation.org>
In-Reply-To: <1224523418.31861.4.camel@brick>
References: <1224523418.31861.4.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008 10:23:38 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> A consolidated implementation will provide this generically through
> asm/byteorder, remove direct includes to avoid breakage when the
> changeover to the new implementation occurs.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, this hunk seems to have been lost when you sent it to Linus, it's possible
> you applied this on top of the -next tree where this file has moved, but the tests
> tree hasn't been pulled yet.
> 
> The rest of the patch went into mainline as 1d8cca44b6a244b7e378546d719041819049a0f9
> 

Grump.  It happens sometimes.  People putting stuff into linux-next and
then not merging it into the next kernel.

> 
>  kernel/rcutorture.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 90b5b12..85cb905 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -42,10 +42,10 @@
>  #include <linux/freezer.h>
>  #include <linux/cpu.h>
>  #include <linux/delay.h>
> -#include <linux/byteorder/swabb.h>
>  #include <linux/stat.h>
>  #include <linux/srcu.h>
>  #include <linux/slab.h>
> +#include <asm/byteorder.h>

Should this be linux/byteorder.h?  (Which weirdly doesn't include
asm/byteorder.h).
