Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbXGQBCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbXGQBCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762654AbXGQBCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:02:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:15833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760117AbXGQBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MMAJ7l4e+UOhRQ1oJ2a/WRvXxg50OP6r6DO0x95hXPDcP9dZKQ1TQuriI7eO7yRiTHBsSpGlg9PhUodMGl34BMTadKdtQgs5YJcu+F3eBnT4tXndxdlORJq2GbmvD88c5Scp3qQ6FZYXlk+ZfolxSqVUwaRzWrCqPuaU7xj61WY=
Message-ID: <469C14E9.5070909@googlemail.com>
Date: Tue, 17 Jul 2007 03:01:29 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org> <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
In-Reply-To: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>   
>
> CONFIG_BLK_DEV_BSG=y
> CONFIG_SCSI=m
>
> block/built-in.o: In function `bsg_init':
> block/bsg.c:1097: undefined reference to `scsi_register_interface'
> make: *** [.tmp_vmlinux1] Error 1
>
> on latest -git.
>   

Should be fixed by this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=29417b899a77aaba1c060f5e123db4f50006f58a

> Satyam
>
>   

Gabriel

