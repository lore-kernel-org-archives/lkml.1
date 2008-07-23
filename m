Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYGWPs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYGWPs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYGWPsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:48:18 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37743 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:48:18 -0400
Date: Wed, 23 Jul 2008 11:48:01 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix another build error
Message-ID: <20080723154801.GB15682@c2.user-mode-linux.org>
References: <20080722174152.GF3081@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080722174152.GF3081@hack.voiplan.pt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 06:41:52PM +0100, WANG Cong wrote:
> 
> Fixed this error:
> 
>   CC      arch/um/drivers/vde_user.o
>   /home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c: In
> function ‘vde_init_libstuff’:
> /home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c:81:
> error: implicit declaration of function ‘kmalloc’
> /home/wangcong/Projects/linux-2.6/arch/um/drivers/vde_user.c:81:
> warning: assignment makes pointer from integer without a cast
> make[2]: *** [arch/um/drivers/vde_user.o] Error 1
> make[1]: *** [arch/um/drivers/vde_user.ko] Error 2
> make: *** [sub-make] Error 2

Thanks - added to the queue.

       	       	  Jeff

-- 
Work email - jdike at linux dot intel dot com
