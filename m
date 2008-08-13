Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYHMU6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYHMU6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHMU63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbYHMU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:58:28 -0400
Date: Wed, 13 Aug 2008 13:57:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [2.6.27 patch] #error for gcc 4.1.{0,1}
Message-Id: <20080813135749.b9985fcc.akpm@linux-foundation.org>
In-Reply-To: <20080813204445.GA7071@cs181140183.pp.htv.fi>
References: <20080813204445.GA7071@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 23:44:45 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> gcc 4.1.0 and 4.1.1 are known to miscompile the kernel:
>   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> 
> Usage of weak functions has become a common pattern in the kernel, and 
> usages get added in each kernel version increasing the probability of 
> bugs with each kernel release.
> 
> This miscompilation of weak functions can result in subtle runtime 
> errors.
> 
> #error for gcc 4.1.0 and 4.1.1 to prevent users from running into
> this bug.
> 
> Note:
> We already printed a #warning for gcc 4.1.0 due to a different bug.

I've been hiding from this because it would wreck a lot of my
cross-compilers, which quite a few other people are using as well.

Vegard, save us!
