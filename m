Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZFAIaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZFAIaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZFAIaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:30:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZFAIaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:30:04 -0400
Date: Mon, 1 Jun 2009 04:30:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/events: introduce __dynamic_array()
Message-ID: <20090601083004.GB2714@infradead.org>
References: <4A2384B1.90100@cn.fujitsu.com> <4A2384D2.3080403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2384D2.3080403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 03:35:46PM +0800, Li Zefan wrote:
> __string() is limited:
> 
>   - it's a char array, but we may want to define array with other types
>   - a source string should be available, but we may just know the string size
> 
> We introduce __dynamic_array() to break those limitations, and __string()
> becomes a wrapper of it. As a side effect, now __get_str() can be used
> in TP_fast_assign but not only TP_print.
> 
> Take XFS for example, we have the string length in the dirent, but the
> string itself is not NULL-terminated, so __dynamic_array() can be used:

Nice one from the users POV!   Thanks a lot.

