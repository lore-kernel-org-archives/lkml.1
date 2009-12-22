Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZLVA2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZLVA2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZLVA2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:28:04 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45543 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbZLVA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:28:01 -0500
Date: Mon, 21 Dec 2009 19:27:57 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
In-Reply-To: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu>
References: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The individual chunks of that patch are all independent; could you 
determine which one of the changes causes the problem?

	-Tim Abbott

On Tue, 22 Dec 2009, richard -rw- weinberger wrote:

> Hi,
> 
> CONFIG_STATIC_LINK=y is broken since 2.6.32.
> The linux binary segfaults immediately.
> 
> This patch introduced the regression (bisected):
> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 is first bad commit
> commit 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80
> Author: Tim Abbott <tabbott@ksplice.com>
> Date:   Thu Sep 24 10:36:20 2009 -0400
> 
>     um: Clean up linker script using standard macros.
> 
>     Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>     Cc: Jeff Dike <jdike@addtoit.com>
>     Cc: user-mode-linux-devel@lists.sourceforge.net
>     Acked-by: Sam Ravnborg <sam@ravnborg.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 43c1b7afe756beb0dc5073195916d54ac41e7546
> fe33dda7c1b15c61a6a65195cc6522beb25e7ba2 M      arch
> 
> Cheers,
> //richard
> 
