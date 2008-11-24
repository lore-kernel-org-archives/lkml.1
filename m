Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYKXLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYKXLlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 06:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKXLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 06:41:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYKXLli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 06:41:38 -0500
Date: Mon, 24 Nov 2008 06:41:24 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081124114124.GA32459@infradead.org>
References: <20081124112842.GA15615@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081124112842.GA15615@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 06:28:42AM -0500, Mathieu Desnoyers wrote:
> - trimmed-down lttv for the kernel tree
>   Need to look at
>   git://git.kernel.org/pub/scm/linux/kernel/git/sam/test.git#master
>   tests/ directory, which permits building userspace tools with the
>   Linux kernel. I recently got the idea of populating debugfs with
>   userspace tools that would sits in kernel module data. How (in)sane
>   does this idea look ? That would seems like a rather good solution to
>   ship the userspace tool with the kernel.

Completely insane I'd say.  Debugfs is per defintion populated from
kernelspace, and adding another mixed user/kernel populated fs like
devfs is a rather bad idea.  I don't quite see any point in shipping
lttv with the kernel tree either, it shouldn't really need knowledge of
the kernel version.

