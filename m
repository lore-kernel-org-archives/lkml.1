Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZKHI1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZKHI1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZKHI1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:27:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59223
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbZKHI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:27:49 -0500
Date: Sun, 08 Nov 2009 00:28:15 -0800 (PST)
Message-Id: <20091108.002815.06996631.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: sparclinux@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc,sparc64: replace parentheses in pmul()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AF3000C.8080607@gmail.com>
References: <4AF3000C.8080607@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Thu, 05 Nov 2009 17:40:44 +0100

> `>>' has a higher precedence than `?' so src2 evaluated to
> either 16 or 0 dependent on the bits set in rs2.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/sparc/kernel/visemul.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> I am not 100% sure that the code was incorrect, however, if it
> was intended I think it is a very strange way to write it.

Your fix is correct, thanks Roel!

I really need to write a testsuite for this VIS emulation code.
