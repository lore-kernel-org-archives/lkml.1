Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbYDPFpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbYDPFpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 01:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYDPFp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 01:45:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:18087 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYDPFpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 01:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=beCC39d+d61qnLLTWIKZ2b9zQgb4Tezka12LruLyBPkL/jbTb1rt8+OYtOFGZ6WgHgY5M+1ScWTT5e9UHCtYRlkuLxnZIT0jZrlYNPv3xcwERGXwcXv/mubsBZHxTThD2N9Lf6KthSj0Js2TXMnWOhCtVi7GMBf3Gqrfpl4lrWI=
Date: Wed, 16 Apr 2008 13:41:27 +0800 (CST)
Message-Id: <20080416.134127.128610481.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Fix another build error
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080414154342.GA9434@c2.user-mode-linux.org>
References: <20080412.233914.54446044.xiyou.wangcong@gmail.com>
	<20080414154342.GA9434@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3G5aGEB026638

From: Jeff Dike <jdike@addtoit.com>
Date: Mon, 14 Apr 2008 11:43:42 -0400
> On Sat, Apr 12, 2008 at 11:39:14PM +0800, WANG Cong wrote:
> > 
> > This patch fixes the following build error.
> > 
> >   CC      arch/um/drivers/mconsole_kern.o
> > /home/wangcong/projects/linux-2.6/arch/um/drivers/mconsole_kern.c:337: error: redefinition of â€˜mconsole_register_devâ€™
> > /home/wangcong/projects/linux-2.6/arch/um/include/mconsole_kern.h:47: error: previous definition of â€˜mconsole_register_devâ€™ was here
> > make[2]: *** [arch/um/drivers/mconsole_kern.o] Error 1
> > make[1]: *** [arch/um/drivers/mconsole_kern.ko] Error 2
> > make: *** [sub-make] Error 2
> 
> This one is fishy.  For one thing, it looks like you reproduce this
> with !CONFIG_MCONSOLE, but I just successfully built a
> !CONFIG_MCONSOLE UML.
> 
> Second, the arch/um/drivers/Makefile looks to me (and the build log
> confirms) that mconsole_kern.c isn't compiled with !CONFIG_MCONSOLE.
> 
> Third, you should ask yourself if there might be a deeper problem that
> needs fixing if you find yourself putting #ifdef CONFIG_FOO in files
> which implement FOO.

Thanks for teaching this!

I will try if it's possible to reproduce this.


 Cong
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
