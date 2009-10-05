Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZJEHpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZJEHpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZJEHpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:45:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40159
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758588AbZJEHpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:45:38 -0400
Date: Mon, 05 Oct 2009 00:45:33 -0700 (PDT)
Message-Id: <20091005.004533.195025386.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091005184357.a6f41165.sfr@canb.auug.org.au>
References: <20091005184357.a6f41165.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 5 Oct 2009 18:43:57 +1100

> Today's linux-next build (sparc64 defconfig) failed like this:
> 
> arch/sparc/oprofile/init.c: In function 'timer_start':
> arch/sparc/oprofile/init.c:46: error: 'HZ' undeclared (first use in this function)
> 
> I have no idea why this just cropped up, but I have added the following
> patch for today.

I suspect:

commit a99bbaf5ee6bad1aca0c88ea65ec6e5373e86184
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sun Oct 4 16:11:37 2009 +0400

    headers: remove sched.h from poll.h
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I'll add your fix to sparc-2.6, thanks!
