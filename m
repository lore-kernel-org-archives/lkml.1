Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYIKXx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYIKXx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 19:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYIKXxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 19:53:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYIKXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 19:53:17 -0400
Date: Thu, 11 Sep 2008 16:52:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, tgraf@suug.ch,
       penberg@cs.helsinki.fi, mingo@elte.hu, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
Message-Id: <20080911165243.125a74cc.akpm@linux-foundation.org>
In-Reply-To: <20080911205933.GA20032@localhost.localdomain>
References: <20080911205933.GA20032@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 22:59:33 +0200
Vegard Nossum <vegard.nossum@gmail.com> wrote:

>   #include <stdio.h>
> 
>   main(void)
>   {
>           printf("%d\n", -1 >= sizeof(int));
>   }
> 

akpm:/home/akpm> gcc -W t.c
t.c: In function 'main':
t.c:5: warning: comparison between signed and unsigned

Make of that what you will :)
