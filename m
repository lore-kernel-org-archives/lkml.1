Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbXLCXf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbXLCXf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXLCXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:35:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42506 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbXLCXfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:35:46 -0500
Date: Mon, 3 Dec 2007 15:34:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add EXPORT_SYMBOL(ksize);
Message-Id: <20071203153459.ac19dae3.akpm@linux-foundation.org>
In-Reply-To: <20071202134841.GI15974@stusta.de>
References: <200712021743.GBH12983.FHOFVJOMFLOStQ@I-love.SAKURA.ne.jp>
	<20071202134841.GI15974@stusta.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007 14:48:42 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> On Sun, Dec 02, 2007 at 05:43:39PM +0900, Tetsuo Handa wrote:
> > 
> > mm/slub.c exports ksize(), but mm/slob.c and mm/slab.c don't. I don't know why.
> >...
> 
> That's due to the fact that my patch to remove this unused export from 
> slub was not yet applied...
> 
> Where is the modular in-kernel user?
> 

binfmt_flat.c, binfmt_elf_fdpic.c.
