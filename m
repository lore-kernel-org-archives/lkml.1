Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZFAI3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZFAI3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 04:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZFAI3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 04:29:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZFAI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 04:29:30 -0400
Date: Mon, 1 Jun 2009 04:29:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/events: put TP_fast_assign into braces
Message-ID: <20090601082927.GA2714@infradead.org>
References: <4A2384B1.90100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2384B1.90100@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 03:35:13PM +0800, Li Zefan wrote:
> Currently TP_fast_assin has a limitation that we can't define local
> variables in it.

Very nice, I hate having to put in the braces myself (and confusing
vim's syntax highlighting with it)

