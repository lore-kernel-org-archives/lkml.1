Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYAQS5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYAQS5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYAQS4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:56:55 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:43535 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYAQS4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:56:54 -0500
Date: Thu, 17 Jan 2008 13:56:25 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [-mm Patch] uml: fix a building error
Message-ID: <20080117185625.GA5724@c2.user-mode-linux.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117135641.GD2693@hacking> <200801171911.16230.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801171911.16230.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 07:11:13PM +0100, Mariusz Kozlowski wrote:
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

Probably - it seems that xlate_dev_mem_ptr can now introduce
side-effects which need to be undone with unxlate_dev_mem_ptr.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
