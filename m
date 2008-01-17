Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYAQS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYAQS4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbYAQS4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:56:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYAQS4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:56:22 -0500
Date: Thu, 17 Jan 2008 10:56:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [-mm Patch] uml: fix a building error
Message-Id: <20080117105606.ff89e9e9.akpm@linux-foundation.org>
In-Reply-To: <200801171911.16230.m.kozlowski@tuxland.pl>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080117135641.GD2693@hacking>
	<200801171911.16230.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 19:11:13 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> > This patch fixes this building error:
> > ...
> > drivers/char/mem.c: In function ‘read_mem’:
> > drivers/char/mem.c:136: error: implicit declaration of function ‘unxlate_dev_mem_ptr’
> > ...
> 
> I see this on sparc64 as well:
> 
>   CC      drivers/char/mem.o
> drivers/char/mem.c: In function 'read_mem':
> drivers/char/mem.c:136: error: implicit declaration of function 'unxlate_dev_mem_ptr'
> make[2]: *** [drivers/char/mem.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> Does sparc64 need similar fix?
> 

The PAT patches strike again.

Ingo, I think you might need to toss some cross-compilers into that build
test setup of yours.

