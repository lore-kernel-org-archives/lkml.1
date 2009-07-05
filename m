Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZGEO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZGEO5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbZGEO5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:57:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbZGEO5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:57:15 -0400
Date: Sun, 5 Jul 2009 07:56:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Mundt <lethal@linux-sh.org>
cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
       zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
In-Reply-To: <20090705145203.GA8326@linux-sh.org>
Message-ID: <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jul 2009, Paul Mundt wrote:
>  			break;
>  	fb_info->node = i;
>  	mutex_init(&fb_info->lock);
> -	mutex_init(&fb_info->mm_lock);

Why not "lock" as well?

		Linus
