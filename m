Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZLaJgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZLaJgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 04:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZLaJgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 04:36:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZLaJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 04:36:13 -0500
Date: Thu, 31 Dec 2009 04:36:04 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       xfs@oss.sgi.com, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Convert some trace events to DEFINE_TRACE
Message-ID: <20091231093604.GA29917@infradead.org>
References: <4B3C64D4.3060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C64D4.3060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 04:46:12PM +0800, Li Zefan wrote:
> Use DECLARE_EVENT_CLASS/DEFINE_EVENT to remove duplicate code:
> 
>    text    data     bss     dec     hex filename
>  871963   35416    3612  910991   de68f fs/xfs/xfs.o.orig
>  575027   35416    3404  613847   95dd7 fs/xfs/xfs.o
> 
> To test this patch, I compared the format files of trace events,
> before and after patching:

I already sent this patch a long time ago, still waiting for Alex to
pick it up.

