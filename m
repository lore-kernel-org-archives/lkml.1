Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbYCZUlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbYCZUlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757022AbYCZUlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:41:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28328 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbYCZUlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:41:13 -0400
Date: Wed, 26 Mar 2008 13:40:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Ben Castricum" <lk08@bencastricum.nl>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH] Microcode: show results on success too plus fix
 typo
Message-Id: <20080326134053.c75656dc.randy.dunlap@oracle.com>
In-Reply-To: <001701c88f7f$1e2b6c80$0602a8c0@links>
References: <001701c88f7f$1e2b6c80$0602a8c0@links>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 21:22:25 +0100 Ben Castricum wrote:

> Show a bit more info when updating microcode. It used to be there but 
> no with DEBUG unset makes it very silent.
> 
> This is my first patch, please let me know if I did anything wrong.
> 
> Signed-off-by: Ben Castricum <lk08@bencastricum.nl>
> 
> diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
> index f2702d0..ca1fd52 100644
> --- a/arch/x86/kernel/microcode.c
> +++ b/arch/x86/kernel/microcode.c
> @@ -336,11 +336,11 @@ static void apply_microcode(int cpu)
> 
>   spin_unlock_irqrestore(&microcode_update_lock, flags);
>   if (val[1] != uci->mc->hdr.rev) {
> -  printk(KERN_ERR "microcode: CPU%d updated from revision "
> +  printk(KERN_ERR "microcode: CPU%d update from revision "
>     "0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
>    return;
>   }
> - pr_debug("microcode: CPU%d updated from revision "
> + printk(KERN_INFO "microcode: CPU%d updated from revision "
>          "0x%x to 0x%x, date = %08x \n",
>          cpu_num, uci->rev, val[1], uci->mc->hdr.date);
>   uci->rev = val[1];

Your mailer client (*cough*) converted tabs to spaces,
so the patch does not apply cleanly now.
You'll need to find a way to send patches that does not mangle
whitespace.


---
~Randy
