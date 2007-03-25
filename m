Return-Path: <linux-kernel-owner+w=401wt.eu-S965089AbXCYEbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965089AbXCYEbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXCYEbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:31:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965089AbXCYEbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:31:22 -0400
Date: Sat, 24 Mar 2007 20:31:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "yuan cooper" <yuanxjtu@hotmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.torokhov@gmail.com
Subject: Re: About GCC4 Optimization
Message-Id: <20070324203118.3ab22ea4.akpm@linux-foundation.org>
In-Reply-To: <BAY144-F24481F006CCA5D5D74D6F4DF680@phx.gbl>
References: <Pine.LNX.4.64.0703242333290.492@paragw-desktop>
	<BAY144-F24481F006CCA5D5D74D6F4DF680@phx.gbl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007 03:42:25 +0000 "yuan cooper" <yuanxjtu@hotmail.com> wrote:

> Hi all:
>  
> during my work, I found there is a bug with GCC4 O2 optimization.
>  
> ---------------------
> float ftmp;
> unsigned long tmp;
> ftmp = 1.0/1024.0;
> tmp  = *(unsigned long *)(&ftmp);
> tmp  = (tmp >> 11) && 0xFFF;
> --------------------- 
>  
> if optimization level is O2, gcc will MOV eax to tmp, but current eax has a random value.
> -O is ok and gcc3 with O2 is ok too.
>  
>  
> I am a kernel newbie, I don't know how to make contributions to janitors, who will help me? It's my first post, any suggestion will be appreciated.

Don't use floating point in kernel code.  At all.
