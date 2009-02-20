Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZBTKvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZBTKvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 05:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZBTKvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 05:51:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:2576 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZBTKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 05:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VSD+fZLz6kW64rGhTYBsPwV3BaA06hmySh8QcsItWELkp3qwfq7XXREUa4/nGIC0Xp
         ZwmnlNC75nlAmPDncStQwfm0uSnX6pJ+WnT0G6kiolQb7eX2yLiAH30m+W604EJeDNoe
         te/6Xzi4eufNoDMyR7Ykyh80HJIvGoLEuYnpI=
MIME-Version: 1.0
In-Reply-To: <1235096630-3099-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1235096630-3099-1-git-send-email-zohar@linux.vnet.ibm.com>
Date: Fri, 20 Feb 2009 13:51:41 +0300
Message-ID: <a4423d670902200251l6087d8afu88409bf4e2e6cb4e@mail.gmail.com>
Subject: Re: [PATCH] integrity: ima scatterlist bug fix
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, David Safford <safford@watson.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/20 Mimi Zohar <zohar@linux.vnet.ibm.com>:
> Based on Alexander Beregalov's post http://lkml.org/lkml/2009/2/19/198
>
> - replaced sg_set_buf() with sg_init_one()
>
>  kernel BUG at include/linux/scatterlist.h:65!
>  invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  last sysfs file:
>  CPU 2
>  Modules linked in:
>  Pid: 1, comm: swapper Not tainted 2.6.29-rc5-next-20090219 #5 PowerEdge 1950
>  RIP: 0010:[<ffffffff8045ec70>]  [<ffffffff8045ec70>] ima_calc_hash+0xc0/0x160
>  RSP: 0018:ffff88007f46bc40  EFLAGS: 00010286
>  RAX: ffffe200032c45e8 RBX: 00000000fffffff4 RCX: 0000000087654321
>  RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff88007cf71048
>  RBP: ffff88007f46bcd0 R08: 0000000000000000 R09: 0000000000000163
>  R10: ffff88007f4707a8 R11: 0000000000000000 R12: ffff88007cf71048
>  R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000009d98
>  FS:  0000000000000000(0000) GS:ffff8800051ac000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>  CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
