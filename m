Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYAQSLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYAQSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYAQSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:11:22 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4798 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYAQSLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:11:21 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [-mm Patch] uml: fix a building error
Date: Thu, 17 Jan 2008 19:11:13 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117135641.GD2693@hacking>
In-Reply-To: <20080117135641.GD2693@hacking>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801171911.16230.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This patch fixes this building error:
> ...
> drivers/char/mem.c: In function ‘read_mem’:
> drivers/char/mem.c:136: error: implicit declaration of function ‘unxlate_dev_mem_ptr’
> ...

I see this on sparc64 as well:

  CC      drivers/char/mem.o
drivers/char/mem.c: In function 'read_mem':
drivers/char/mem.c:136: error: implicit declaration of function 'unxlate_dev_mem_ptr'
make[2]: *** [drivers/char/mem.o] Error 1
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

Does sparc64 need similar fix?

Regards,

	Mariusz
